part of 'email_phone_bloc.dart';

sealed class EmailPhoneEvent extends Equatable {
  const EmailPhoneEvent();

  @override
  List<Object> get props => [];
}

final class SwitchModesEvent extends EmailPhoneEvent {
  const SwitchModesEvent({
    required this.mode,
  });

  final String mode;

  @override
  List<Object> get props => [mode];
}

final class EmailOnChangeEvent extends EmailPhoneEvent {
  const EmailOnChangeEvent(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class PhoneOnChangeEvent extends EmailPhoneEvent {
  const PhoneOnChangeEvent(this.phone);

  final String phone;

  @override
  List<Object> get props => [phone];
}

final class ConfirmEmailOrPhoneEvent extends EmailPhoneEvent {
  const ConfirmEmailOrPhoneEvent({this.email, this.phone});

  final String? email;
  final String? phone;

  @override
  List<Object> get props => [email!, phone!];
}
