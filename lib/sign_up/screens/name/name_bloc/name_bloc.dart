import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'name_event.dart';
part 'name_state.dart';

class NameBloc extends Bloc<NameEvent, NameState> {
  NameBloc() : super(NameInitial()) {
    on<OnChangeInputEvent>(_onChangeInputHandler);
    on<SignUpAndAcceptEvent>(_onSignUpAndAccept);
  }

  void _onChangeInputHandler(
      OnChangeInputEvent event, Emitter<NameState> emit) {
    if (event.firstName.isEmpty || event.lastName.isEmpty) {
      emit(ButtonIsDisabled());
    } else {
      emit(ButtonIsEnabled());
    }
  }

  FutureOr<void> _onSignUpAndAccept(
      SignUpAndAcceptEvent event, Emitter<NameState> emit) {
    emit(NameLoading());
    emit(NameRegistered());
  }
}
