import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc() : super(LogInInitial()) {
    on<LoggingInEvent>(_logInHandler);
    on<OnChangeInputEvent>(_onChangeInputHandler);
  }

  Future<void> _logInHandler(
      LoggingInEvent event, Emitter<LogInState> emit) async {
    emit(LoggingIn());
    emit(LogInSuccess());
  }

  void _onChangeInputHandler(
      OnChangeInputEvent event, Emitter<LogInState> emit) {
    var emailError = '';
    var passwordError = '';
    if (event.email.isEmpty) {
      emailError = 'This field is required';
      emit(LogInInvalidState(
        emailError: emailError,
        passwordError: passwordError,
      ));
    } else if (event.email.length < 5) {
      emailError = 'Must have at least 5 characters';
      emit(LogInInvalidState(
        emailError: emailError,
        passwordError: passwordError,
      ));
    }
    if (event.password.isEmpty) {
      passwordError = 'This field is required';
      emit(LogInInvalidState(
        emailError: emailError,
        passwordError: passwordError,
      ));
    } else if (event.password.length < 8) {
      passwordError = 'Your password must have at least 8 characters';
      emit(LogInInvalidState(
        emailError: emailError,
        passwordError: passwordError,
      ));
    }
    if (event.email.length >= 5 && event.password.length >= 8) {
      emit(LoginValidState());
    }
  }
}
