import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'email_phone_event.dart';
part 'email_phone_state.dart';

class EmailPhoneBloc extends Bloc<EmailPhoneEvent, EmailPhoneState> {
  EmailPhoneBloc() : super(EmailPhoneInitial()) {
    on<SwitchModesEvent>(_onSwitchModes);
    on<EmailOnChangeEvent>(_onEmailOnChange);
    on<PhoneOnChangeEvent>(_onMobileOnChange);
    on<ConfirmEmailOrPhoneEvent>(_onConfirmEmailOrPhone);
  }

  void _onSwitchModes(SwitchModesEvent event, Emitter<EmailPhoneState> emit) {
    if (event.mode == 'phone') {
      emit(PhoneMode(''));
    } else {
      emit(EmailMode(''));
    }
  }

  void _onEmailOnChange(
      EmailOnChangeEvent event, Emitter<EmailPhoneState> emit) {
    emit(EmailMode(event.email));
  }

  void _onMobileOnChange(
      PhoneOnChangeEvent event, Emitter<EmailPhoneState> emit) {
    emit(PhoneMode(event.phone));
  }

  FutureOr<void> _onConfirmEmailOrPhone(
      ConfirmEmailOrPhoneEvent event, Emitter<EmailPhoneState> emit) {
    print('F**k off');
    if (event.email != null && event.email!.isNotEmpty) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);

      if (regex.hasMatch(event.email!)) {
        emit(ConfirmedEmailOrPhone());
      } else {
        emit(const InvalidEmail('Your email is invalid.'));
      }
    } else if (event.phone != null && event.phone!.isNotEmpty) {
      if (int.tryParse(event.phone!) != null) {
        emit(ConfirmedEmailOrPhone());
      } else {
        emit(const InvalidPhone('Your phone number is invalid'));
      }
    }
  }
}
