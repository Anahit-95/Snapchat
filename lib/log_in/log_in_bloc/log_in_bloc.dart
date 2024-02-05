import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/user_model.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc({
    required ValidationRepoImpl validationRepo,
    required DatabaseRepoImpl dbRepo,
  })  : _validationRepo = validationRepo,
        _dbRepo = dbRepo,
        super(LogInInitial()) {
    on<LoggingInEvent>(_onLoggingIn);
    on<OnChangeInputEvent>(_onChangeInput);
  }
  final ValidationRepoImpl _validationRepo;
  final DatabaseRepoImpl _dbRepo;

  Future<void> _onLoggingIn(
      LoggingInEvent event, Emitter<LogInState> emit) async {
    try {
      emit(LoggingIn());
      final user = await _dbRepo.loginUser(
        text: event.email,
        password: event.password,
        validationRepo: _validationRepo,
      );
      if (user != null) {
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
    if (_validationRepo.isValidUsername(event.email)) {
      emailError = '';
    } else {
      emailError = 'Must have at least 5 characters';
    }
    if (_validationRepo.isValidPassword(event.password)) {
      passwordError = '';
    } else {
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
