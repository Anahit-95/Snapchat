import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';
import 'package:snapchat/core/validation_repository/validation_repo_impl.dart';

part 'sign_up_password_event.dart';
part 'sign_up_password_state.dart';

class SignUpPasswordBloc
    extends Bloc<SignUpPasswordEvent, SignUpPasswordState> {
  SignUpPasswordBloc(
      {required ValidationRepoImpl validationRepo,
      required DatabaseRepoImpl dbRepo})
      : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        super(PasswordInitial()) {
    on<OnChangePasswordInputEvent>(_onOnChangePasswordInput);
    on<ConfirmingPasswordEvent>(_onConfirmingPasswordEvent);
  }

  final ValidationRepoImpl _validationRepo;
  final DatabaseRepoImpl _dbRepo;

  void _onOnChangePasswordInput(
      OnChangePasswordInputEvent event, Emitter<SignUpPasswordState> emit) {
    if (_validationRepo.isValidPasswordAndNotEmpty(event.password)) {
      emit(ValidPassword());
    } else {
      emit(
        const InvalidPassword('Your password must have at least 8 characters'),
      );
    }
  }

  Future<void> _onConfirmingPasswordEvent(
      ConfirmingPasswordEvent event, Emitter<SignUpPasswordState> emit) async {
    try {
      emit(LoadingPassword());
      await _dbRepo.insertUser(event.user);
      emit(ConfirmPassword());
    } catch (e) {
      print(e);
      emit(InvalidPassword('Failed to sign up: ${e.toString()}'));
    }
  }
}
