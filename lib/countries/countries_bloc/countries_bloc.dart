import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:snapchat/core/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/countries/repository/load_countries_repo_impl.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc({
    required LoadCountriesRepoImpl apiRepo,
    required DatabaseRepoImpl dbRepo,
  })  : _apiRepo = apiRepo,
        _dbRepo = dbRepo,
        super(CountriesInitial()) {
    on<LoadCountriesEvent>(_onLoadCountriesEvent);
    on<GetCountriesApiEvent>(_onGetCountriesApi);
    on<SearchingCountriesEvent>(_onSearchingCountries);
  }

  final LoadCountriesRepoImpl _apiRepo;
  final DatabaseRepoImpl _dbRepo;
  List<CountryModel> _countries = [];

  Future<void> _onLoadCountriesEvent(
      LoadCountriesEvent event, Emitter<CountriesState> emit) async {
    final databaseExists = await _dbRepo.countriesTableExist();
    if (databaseExists) {
      try {
        emit(LoadingCountries());
        _countries = await _dbRepo.getCountries();
        print('loaded from database');
        emit(CountriesLoaded(countries: _countries));
      } catch (e) {
        emit(const CountriesError('Failed loading countries from database.'));
      }
    } else {
      try {
        emit(LoadingCountries());
        final data =
            await rootBundle.loadString('assets/resources/country_codes.json');
        final List<dynamic> jsonList = jsonDecode(data);

        _countries =
            jsonList.map((json) => CountryModel.fromMap(json)).toList();
        print('loaded from asset');
        emit(CountriesLoaded(countries: _countries));
      } catch (e) {
        emit(const CountriesError('Failed loading countries.'));
      }
    }
  }

  Future<void> _onGetCountriesApi(
      GetCountriesApiEvent event, Emitter<CountriesState> emit) async {
    final databaseExists = await _dbRepo.countriesTableExist();
    if (databaseExists) {
      try {
        emit(LoadingCountries());
        print('calling db');
        _countries = await _dbRepo.getCountries();
        print('loaded from database');
        emit(CountriesLoaded(countries: _countries));
      } catch (e) {
        emit(const CountriesError('Failed loading countries from database.'));
      }
    } else {
      try {
        emit(LoadingCountries());
        _countries = await _apiRepo.loadCountries();
        print('loaded from api');
        await _dbRepo.insertCountries(_countries);
        emit(CountriesLoaded(countries: _countries));
      } catch (e) {
        emit(const CountriesError('Failed loading countries.'));
      }
    }
  }

  void _onSearchingCountries(
      SearchingCountriesEvent event, Emitter<CountriesState> emit) {
    if (event.countryName.isNotEmpty) {
      final findedCountries = _countries
          .where(
            (country) =>
                country.countryName
                    .toLowerCase()
                    .contains(event.countryName.toLowerCase()) ||
                country.countryCode
                    .toLowerCase()
                    .contains(event.countryName.toLowerCase()) ||
                country.phoneCode.contains(event.countryName.toLowerCase()),
          )
          .toList();
      emit(CountriesFound(countries: findedCountries));
    } else {
      emit(CountriesLoaded(countries: _countries));
    }
  }
}
