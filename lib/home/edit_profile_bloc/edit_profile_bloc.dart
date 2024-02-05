import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(
      {required ValidationRepoImpl validationRepo,
      required DatabaseRepoImpl dbRepo})
      : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        super(EditProfileInitial()) {
    on<EditingOnChangeEvent>(_onEditingOnChange);
    on<SaveProfileChanges>(_onSaveProfileChanges);
  }

  final ValidationRepoImpl _validationRepo;
  final DatabaseRepoImpl _dbRepo;

  List<UserModel> _allUsers = [];

  Future<void> _onEditingOnChange(
      EditingOnChangeEvent event, Emitter<EditProfileState> emit) async {
    String firstNameError;
    String lastNameError;
    String birthdayError;
    String usernameError;
    String emailError = '';
    String phoneError = '';
    String passwordError = '';

    if (_allUsers.isEmpty) {
      _allUsers = await _dbRepo.getAllUsers();
    }

    if (event.firstName.isEmpty) {
      firstNameError = 'This field must not be empty.';
    } else {
      firstNameError = '';
    }
    if (event.lastName.isEmpty) {
      lastNameError = 'This field must not be empty.';
    } else {
      lastNameError = '';
    }
    if (_validationRepo.isValidBirthday(event.birthday)) {
      birthdayError = '';
    } else {
      birthdayError = 'You must be at least 16 year old.';
    }
    if (_validationRepo.isValidUsernameAndNotEmpty(event.username)) {
      if (_validationRepo.isUsernameAvailable(
              username: event.username, allUsers: _allUsers) ||
          event.username == event.user.username) {
        usernameError = '';
      } else {
        usernameError = 'This username is already in use.';
      }
    } else {
      usernameError = 'Your username must have at least 5 characters';
    }

    if ((event.email == null || event.email!.isEmpty) &&
        (event.phone == null || event.phone!.isEmpty)) {
      emailError = 'You must provide either email or phone';
      phoneError = 'You must provide either email or phone';
    } else if (event.email!.isNotEmpty) {
      phoneError = '';
      if (_validationRepo.isValidEmail(event.email!)) {
        emailError = 'Your email is invalid';
      } else if (_validationRepo.isEmailAvailable(
              email: event.email!, allUsers: _allUsers) ||
          event.email! == event.user.email) {
        emailError = '';
      } else {
        emailError = 'This email is already in use';
      }
    }

    if (firstNameError.isEmpty &&
        lastNameError.isEmpty &&
        birthdayError.isEmpty &&
        usernameError.isEmpty &&
        emailError.isEmpty &&
        phoneError.isNotEmpty) {
      emit(ValidEditState());
    } else {
      print(firstNameError);
      print(lastNameError);
      print(birthdayError);
      print(usernameError);
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

  FutureOr<void> _onSaveProfileChanges(
      SaveProfileChanges event, Emitter<EditProfileState> emit) {}
}