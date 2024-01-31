import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_password_event.dart';
part 'sign_up_password_state.dart';

class SignUpPasswordBloc
    extends Bloc<SignUpPasswordEvent, SignUpPasswordState> {
  SignUpPasswordBloc() : super(PasswordInitial()) {
    on<OnChangePasswordInputEvent>(_onOnChangePasswordInput);
    on<ConfirmingPasswordEvent>(_onConfirmingPasswordEvent);
  }

  void _onOnChangePasswordInput(
      OnChangePasswordInputEvent event, Emitter<SignUpPasswordState> emit) {
    if (event.password.length >= 8) {
      emit(ValidPassword());
    } else {
      emit(const InvalidPassword(
          'Your password must have at least 8 characters'));
    }
  }

  FutureOr<void> _onConfirmingPasswordEvent(
      ConfirmingPasswordEvent event, Emitter<SignUpPasswordState> emit) {
    emit(LoadingPassword());
    emit(ConfirmPassword());
  }
}
