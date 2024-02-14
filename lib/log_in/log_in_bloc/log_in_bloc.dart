import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo_impl.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/user_realm_repo_impl.dart';
// import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc({
    required ValidationRepoImpl validationRepo,
    // required UsersDBRepoImpl dbRepo,
    required UserRealmRepoImpl dbRepo,
    required StorageRepoImpl storageRepo,
  })  : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        _storageRepo = storageRepo,
        super(LogInInitial()) {
    on<LoggingInEvent>(_onLoggingIn);
    on<OnChangeInputEvent>(_onChangeInput);
  }
  final ValidationRepoImpl _validationRepo;
  // final UsersDBRepoImpl _dbRepo;
  final UserRealmRepoImpl _dbRepo;
  final StorageRepoImpl _storageRepo;

  Future<void> _onLoggingIn(
      LoggingInEvent event, Emitter<LogInState> emit) async {
    try {
      emit(LoggingIn());
      final user = await _dbRepo.loginUser(
        text: event.email,
        password: event.password,
        validationRepo: _validationRepo,
      );
      final users = await _dbRepo.getAllUsers();
      print(users);
      if (user != null) {
        _storageRepo.setUser(
            username: user.username!, password: user.password!);
        emit(LogInSuccess(user: user));
      } else {
        emit(const LogInError('Wrong username or password'));
      }
    } catch (e) {
      print(e.toString());
      emit(const LogInError('Failed to login'));
    }
  }

  void _onChangeInput(OnChangeInputEvent event, Emitter<LogInState> emit) {
    var emailError = '';
    var passwordError = '';
    if (!_validationRepo.isValidUsername(event.email)) {
      emailError = 'Must have at least 5 characters';
    }
    if (!_validationRepo.isValidPassword(event.password)) {
      passwordError = 'Your password must have at least 8 characters';
    }

    if (_validationRepo.isValidLoginState(
        email: event.email, password: event.password)) {
      emit(LoginValidState());
    } else {
      emit(LogInInvalidState(
        emailError: emailError,
        passwordError: passwordError,
      ));
    }
  }
}
