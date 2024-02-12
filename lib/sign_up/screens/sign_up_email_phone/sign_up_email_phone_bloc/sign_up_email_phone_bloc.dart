import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:country_codes/country_codes.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/countries_repository/countries_repo_impl.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/country_model.dart';

part 'sign_up_email_phone_event.dart';
part 'sign_up_email_phone_state.dart';

class SignUpEmailPhoneBloc
    extends Bloc<SignUpEmailPhoneEvent, SignUpEmailPhoneState> {
  SignUpEmailPhoneBloc({
    required ValidationRepoImpl validationRepo,
    required UsersDBRepoImpl dbRepo,
    required CountriesRepoImpl countriesRepo,
  })  : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        _countriesRepo = countriesRepo,
        super(EmailPhoneInitial()) {
    on<EmailOnChangeEvent>(_onEmailOnChange);
    on<PhoneOnChangeEvent>(_onMobileOnChange);
    on<GetCountryEvent>(_onGetCountry);
  }

  final ValidationRepoImpl _validationRepo;
  final UsersDBRepoImpl _dbRepo;
  final CountriesRepoImpl _countriesRepo;

  Future<void> _onGetCountry(
      GetCountryEvent event, Emitter<SignUpEmailPhoneState> emit) async {
    emit(FindingCountry());
    final countries = await _countriesRepo.loadCountries();

    final locale = CountryCodes.getDeviceLocale()!;
    final countryCode = locale.countryCode!;

    final country =
        countries.firstWhere((country) => country.countryCode == countryCode);
    emit(CountryFounded(country: country, countries: countries));
  }

  Future<void> _onEmailOnChange(
      EmailOnChangeEvent event, Emitter<SignUpEmailPhoneState> emit) async {
    if (_validationRepo.isValidEmail(event.email)) {
      final existingUser = await _dbRepo.getUserByEmail(event.email);
      if (existingUser == null) {
        emit(EmailMode(event.email));
      } else {
        emit(const InvalidEmail('This email is already in use'));
      }
    } else {
      emit(const InvalidEmail('Your email is invalid.'));
    }
  }

  Future<void> _onMobileOnChange(
      PhoneOnChangeEvent event, Emitter<SignUpEmailPhoneState> emit) async {
    if (_validationRepo.isValidPhoneNumber(event.phoneNumber)) {
      final existingUser =
          await _dbRepo.getUserByPhone(event.phoneCode, event.phoneNumber);
      if (existingUser == null) {
        emit(PhoneMode(event.phoneNumber));
      } else {
        emit(const InvalidPhone('This number is already in use'));
      }
    } else {
      emit(const InvalidPhone('Your phone number is invalid'));
    }
  }
}
