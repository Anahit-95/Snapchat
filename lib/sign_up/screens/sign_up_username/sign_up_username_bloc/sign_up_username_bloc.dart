import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {
  SignUpUsernameBloc() : super(UsernameInitial()) {
    on<OnChangeInputEvent>(_onOnChangeInputEvent);
    on<ConfirmingUsername>(_onConfirmingUsername);
  }

  FutureOr<void> _onOnChangeInputEvent(
      OnChangeInputEvent event, Emitter<SignUpUsernameState> emit) {
    if (event.username.length >= 5) {
      // TODO: Do an actioin to ckeck if username is in use
      if (event.username != 'Anahit') {
        emit(UsernameAvailable());
      } else {
        emit(const InvalidUsername('This username is already in use.'));
      }
    } else {
      emit(
        const InvalidUsername('Your username must have at least 5 characters'),
      );
    }
  }

  FutureOr<void> _onConfirmingUsername(
      ConfirmingUsername event, Emitter<SignUpUsernameState> emit) {
    emit(UsernameLoading());
    emit(UsernameConfirmed());
  }
}
