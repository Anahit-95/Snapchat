import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'username_event.dart';
part 'username_state.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  UsernameBloc() : super(UsernameInitial()) {
    on<OnChangeInputEvent>(_onOnChangeInputEvent);
    on<ConfirmingUsername>(_onConfirmingUsername);
  }

  FutureOr<void> _onOnChangeInputEvent(
      OnChangeInputEvent event, Emitter<UsernameState> emit) {
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
      ConfirmingUsername event, Emitter<UsernameState> emit) {
    emit(UsernameLoading());
    emit(UsernameConfirmed());
  }
}
