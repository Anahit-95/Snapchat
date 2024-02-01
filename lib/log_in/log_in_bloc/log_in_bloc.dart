import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/validation_repository/validation_repo_impl.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc({required ValidationRepoImpl repoImpl})
      : _repoImpl = repoImpl,
        super(LogInInitial()) {
    on<LoggingInEvent>(_onLoggingIn);
    on<OnChangeInputEvent>(_onChangeInput);
  }
  final ValidationRepoImpl _repoImpl;

  Future<void> _onLoggingIn(
      LoggingInEvent event, Emitter<LogInState> emit) async {
    emit(LoggingIn());
    emit(LogInSuccess());
  }

  void _onChangeInput(OnChangeInputEvent event, Emitter<LogInState> emit) {
    var emailError = '';
    var passwordError = '';
    if (_repoImpl.isValidUsername(event.email)) {
      emailError = '';
    } else {
      emailError = 'Must have at least 5 characters';
    }
    if (_repoImpl.isValidPassword(event.password)) {
      passwordError = '';
    } else {
      passwordError = 'Your password must have at least 8 characters';
    }
    if (_repoImpl.isValidLoginState(
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
