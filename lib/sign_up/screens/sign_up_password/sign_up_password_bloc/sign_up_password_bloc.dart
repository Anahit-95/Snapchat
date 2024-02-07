import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';

part 'sign_up_password_event.dart';
part 'sign_up_password_state.dart';

class SignUpPasswordBloc
    extends Bloc<SignUpPasswordEvent, SignUpPasswordState> {
  SignUpPasswordBloc({
    required ValidationRepoImpl validationRepo,
    required DatabaseRepoImpl dbRepo,
    required StorageRepoImpl storageRepo,
  })  : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        _storageRepo = storageRepo,
        super(PasswordInitial()) {
    on<OnChangePasswordInputEvent>(_onOnChangePasswordInput);
    on<ConfirmingPasswordEvent>(_onConfirmingPasswordEvent);
  }

  final ValidationRepoImpl _validationRepo;
  final DatabaseRepoImpl _dbRepo;
  final StorageRepoImpl _storageRepo;

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
      await _storageRepo.setUser(
        username: event.user.username,
        password: event.user.password,
      );
      emit(ConfirmPassword());
    } catch (e) {
      print(e);
      emit(SignUpError('Failed to sign up: ${e.toString()}'));
    }
  }
}
