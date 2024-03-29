import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:country_codes/country_codes.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/countries_repository/countries_repo_impl.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo_impl.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/user_realm_repo_impl.dart';
// import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/core/models/user_model.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required ValidationRepoImpl validationRepo,
    // required UsersDBRepoImpl dbRepo,
    required UserRealmRepoImpl dbRepo,
    required CountriesRepoImpl countriesRepo,
    required StorageRepoImpl storageRepo,
  })  : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        _countriesRepo = countriesRepo,
        _storageRepo = storageRepo,
        super(EditProfileInitial()) {
    on<GetCountryEvent>(_onGetCountry);
    on<EditingOnChangeEvent>(_onEditingOnChange);
    on<SaveProfileChanges>(_onSaveProfileChanges);
    on<LogOutEvent>(onLogOut);
  }

  final ValidationRepoImpl _validationRepo;
  // final UsersDBRepoImpl _dbRepo;
  final UserRealmRepoImpl _dbRepo;
  final CountriesRepoImpl _countriesRepo;
  final StorageRepoImpl _storageRepo;

  Future<void> _onGetCountry(
      GetCountryEvent event, Emitter<EditProfileState> emit) async {
    emit(FindingCountry());
    final countries = await _countriesRepo.loadCountries();
    String countryCode;
    if (event.countryCode != null) {
      countryCode = event.countryCode!;
    } else {
      final locale = CountryCodes.getDeviceLocale()!;
      countryCode = locale.countryCode!;
    }
    final country =
        countries.firstWhere((country) => country.countryCode == countryCode);
    emit(CountryFounded(country: country, countries: countries));
  }

  Future<void> _onEditingOnChange(
      EditingOnChangeEvent event, Emitter<EditProfileState> emit) async {
    var firstNameError = '';
    var lastNameError = '';
    var birthdayError = '';
    var usernameError = '';
    var emailError = '';
    var phoneError = '';
    var passwordError = '';

    if (event.firstName.isEmpty) {
      firstNameError = 'This field must not be empty.';
    }
    if (event.lastName.isEmpty) {
      lastNameError = 'This field must not be empty.';
    }
    if (!_validationRepo.isValidBirthday(event.birthday)) {
      birthdayError = 'You must be at least 16 year old.';
    }
    if (_validationRepo.isValidUsernameAndNotEmpty(event.username)) {
      final existingUser = await _dbRepo.getUserByUsername(event.username);
      if (existingUser != null && event.username != event.user.username) {
        usernameError = 'This username is already in use.';
      }
    } else {
      usernameError = 'Your username must have at least 5 characters';
    }

    if (event.email!.isNotEmpty) {
      if (_validationRepo.isValidEmail(event.email!)) {
        final existingUser = await _dbRepo.getUserByEmail(event.email!);
        if (existingUser != null && event.email! != event.user.email) {
          emailError = 'This email is already in use';
        }
      } else {
        emailError = 'Your email is invalid';
      }
    } else if (event.email!.isEmpty && event.phoneNumber!.isEmpty) {
      emailError = 'You must provide either email or phone';
    } else {
      emailError = '';
    }

    if (event.phoneNumber!.isNotEmpty) {
      if (_validationRepo.isValidPhoneNumber(event.phoneNumber!)) {
        final existingUser = await _dbRepo.getUserByPhone(
          event.phoneCode!,
          event.phoneNumber!,
        );
        if (existingUser == null ||
            (event.phoneCode == event.user.phoneCode &&
                event.phoneNumber == event.user.phoneNumber)) {
          phoneError = '';
        } else {
          phoneError = 'This phone number is already in use';
        }
      } else {
        phoneError = 'Your phone number is invalid';
      }
    } else if (event.phoneNumber!.isEmpty && event.email!.isEmpty) {
      phoneError = 'You must provide either email or phone';
    } else {
      phoneError = '';
    }

    if (!_validationRepo.isValidPasswordAndNotEmpty(event.password)) {
      passwordError = 'Your password must have at least 8 characters';
    }

    if (firstNameError.isEmpty &&
        lastNameError.isEmpty &&
        birthdayError.isEmpty &&
        usernameError.isEmpty &&
        emailError.isEmpty &&
        phoneError.isEmpty &&
        passwordError.isEmpty) {
      emit(ValidEditState());
    } else {
      emit(InvalidEditState(
        firstNameError: firstNameError,
        lastNameError: lastNameError,
        birthdayError: birthdayError,
        usernameError: usernameError,
        emailError: emailError,
        phoneError: phoneError,
        passwordError: passwordError,
      ));
    }
  }

  Future<void> _onSaveProfileChanges(
      SaveProfileChanges event, Emitter<EditProfileState> emit) async {
    emit(LoadingEditProfile());
    await _storageRepo.setUser(
      username: event.user.username!,
      password: event.user.password!,
    );
    await _dbRepo.updateUser(
        oldUsername: event.username, updatedUser: event.user);
    emit(UpdatedProfile());
  }

  Future<void> onLogOut(
      LogOutEvent event, Emitter<EditProfileState> emit) async {
    emit(LogingOutState());
    await _storageRepo.deleteUser();
    emit(LogOutState());
  }
}
