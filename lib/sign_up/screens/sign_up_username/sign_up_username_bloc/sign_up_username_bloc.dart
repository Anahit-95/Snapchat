import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat/core/validation_repository/validation_repo_impl.dart';

part 'sign_up_username_event.dart';
part 'sign_up_username_state.dart';

class SignUpUsernameBloc
    extends Bloc<SignUpUsernameEvent, SignUpUsernameState> {
  SignUpUsernameBloc({required ValidationRepoImpl repoImpl})
      : _repoImpl = repoImpl,
        super(UsernameInitial()) {
    on<OnChangeInputEvent>(_onOnChangeInputEvent);
  }
  final ValidationRepoImpl _repoImpl;

  FutureOr<void> _onOnChangeInputEvent(
      OnChangeInputEvent event, Emitter<SignUpUsernameState> emit) {
    if (_repoImpl.isValidUsernameAndNotEmpty(event.username)) {
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
}
