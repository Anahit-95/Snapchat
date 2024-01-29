import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_birthday_event.dart';
part 'sign_up_birthday_state.dart';

class SignUpBirthdayBloc
    extends Bloc<SignUpBirthdayEvent, SignUpBirthdayState> {
  SignUpBirthdayBloc() : super(BirthdayInitial()) {
    on<SelectingDate>(_onSelectingDate);
    on<ConfirmingDate>(_onConfirmingDate);
  }

  FutureOr<void> _onSelectingDate(
      SelectingDate event, Emitter<SignUpBirthdayState> emit) {
    if (event.birthDate != null) {
      emit(BirthdaySelected(event.birthDate!));
      final now = DateTime.now();
      final difference = now.difference(event.birthDate!);
      final years = difference.inDays ~/ 365;
      if (years < 16) {
        emit(InvalidBirthday());
      } else {
        emit(ValidBirthday());
      }
    } else {
      emit(InvalidBirthday());
    }
  }

  FutureOr<void> _onConfirmingDate(
      ConfirmingDate event, Emitter<SignUpBirthdayState> emit) {
    emit(LoadingBirthday());
    // TODO: Do some actions with date
    emit(BirthdayConfirmed());
  }
}
