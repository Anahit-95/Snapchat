import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/countries_repository/countries_repo_impl.dart';
import 'package:snapchat/core/models/country_model.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc({
    required CountriesRepoImpl countriesRepo,
  })  : _countriesRepo = countriesRepo,
        super(CountriesInitial()) {
    // on<LoadCountriesEvent>(_onLoadCountriesEvent);
    on<GetCountriesApiEvent>(_onGetCountriesApi);
    on<SearchingCountriesEvent>(_onSearchingCountries);
  }
  final CountriesRepoImpl _countriesRepo;
  List<CountryModel> _countries = [];

  Future<void> _onGetCountriesApi(
      GetCountriesApiEvent event, Emitter<CountriesState> emit) async {
    try {
      emit(LoadingCountries());
      if (_countries.isEmpty) {
        _countries = await _countriesRepo.loadCountries();
      }
      emit(CountriesLoaded(countries: _countries));
    } catch (e) {
      emit(CountriesError(e.toString()));
    }
  }

  void _onSearchingCountries(
      SearchingCountriesEvent event, Emitter<CountriesState> emit) {
    if (event.countryName.isNotEmpty) {
      final findedCountries = _countriesRepo.searchCountries(
        countryName: event.countryName,
        countries: _countries,
      );
      emit(CountriesFound(countries: findedCountries));
    } else {
      emit(CountriesLoaded(countries: _countries));
    }
  }

  // Future<void> _onLoadCountriesEvent(
  //     LoadCountriesEvent event, Emitter<CountriesState> emit) async {
  //   final databaseExists = await _dbRepo.countriesTableExist();
  //   if (databaseExists) {
  //     try {
  //       emit(LoadingCountries());
  //       _countries = await _dbRepo.getCountries();
  //       print('loaded from database');
  //       emit(CountriesLoaded(countries: _countries));
  //     } catch (e) {
  //       emit(const CountriesError('Failed loading countries from database.'));
  //     }
  //   } else {
  //     try {
  //       emit(LoadingCountries());
  //       final data =
  //           await rootBundle.loadString('assets/resources/country_codes.json');
  //       final List<dynamic> jsonList = jsonDecode(data);

  //       _countries =
  //           jsonList.map((json) => CountryModel.fromMap(json)).toList();
  //       print('loaded from asset');
  //       emit(CountriesLoaded(countries: _countries));
  //     } catch (e) {
  //       emit(const CountriesError('Failed loading countries.'));
  //     }
  //   }
  // }
}
