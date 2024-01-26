import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc() : super(LogInInitial()) {
    on<LoggingInEvent>(_logInHandler);
    on<ActivateButtonEvent>(_activateButtonHandler);
  }

  Future<void> _logInHandler(
      LoggingInEvent event, Emitter<LogInState> emit) async {
    var emailError = '';
    var passwordError = '';
    if (event.email.isEmpty) {
      emailError = 'This field is required';
    }
    if (event.password.isEmpty) {
      passwordError = 'This field is required';
    } else if (event.password.length < 8) {
      passwordError = 'Your password must have at least 8 characters';
    }
    if (emailError.isNotEmpty || passwordError.isNotEmpty) {
      emit(LogInInvalidState(
        emailError: emailError,
        passwordError: passwordError,
      ));
    } else {
      emit(LoggingIn());
      emit(LogInSuccess());
    }
  }

  void _activateButtonHandler(
      ActivateButtonEvent event, Emitter<LogInState> emit) {
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(ButtonIsDisabled());
    } else {
      emit(ButtonIsEnabled());
    }
  }
}
