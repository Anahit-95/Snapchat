import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'birthday_event.dart';
part 'birthday_state.dart';

class BirthdayBloc extends Bloc<BirthdayEvent, BirthdayState> {
  BirthdayBloc() : super(BirthdayInitial()) {
    on<SelectingDate>(_onSelectingDate);
    on<ConfirmingDate>(_onConfirmingDate);
  }

  FutureOr<void> _onSelectingDate(
      SelectingDate event, Emitter<BirthdayState> emit) {
    if (event.birthDate == null) {
      emit(BirthdayInitial());
    } else {
      emit(BirthdaySelected(event.birthDate!));
    }
  }

  FutureOr<void> _onConfirmingDate(
      ConfirmingDate event, Emitter<BirthdayState> emit) {
    final now = DateTime.now();
    final difference = now.difference(event.birthDate);
    final years = difference.inDays ~/ 365;

    if (years < 16) {
      emit(InvalidBirthday());
    } else {
      emit(LoadingBirthday());
      // TODO: Do some actions with date
      emit(BirthdayConfirmed());
    }
  }
}
