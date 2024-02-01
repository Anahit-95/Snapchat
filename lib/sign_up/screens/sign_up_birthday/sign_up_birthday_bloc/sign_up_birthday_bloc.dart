import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_birthday_event.dart';
part 'sign_up_birthday_state.dart';

class SignUpBirthdayBloc
    extends Bloc<SignUpBirthdayEvent, SignUpBirthdayState> {
  SignUpBirthdayBloc() : super(BirthdayInitial()) {
    on<SelectingDate>(_onSelectingDate);
    on<OpenDatePickerEvent>(_onOpenDatePicker);
  }

  FutureOr<void> _onSelectingDate(
      SelectingDate event, Emitter<SignUpBirthdayState> emit) {
    emit(BirthdaySelected(event.birthDate));
    final now = DateTime.now();
    final difference = now.difference(event.birthDate);
    final years = difference.inDays ~/ 365;
    if (years < 16) {
      emit(InvalidBirthday());
    } else {
      emit(ValidBirthday());
    }
  }

  void _onOpenDatePicker(
      OpenDatePickerEvent event, Emitter<SignUpBirthdayState> emit) {
    emit(OpenDatePicker());
  }
}
