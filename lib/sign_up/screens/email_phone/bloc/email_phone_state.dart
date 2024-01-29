part of 'email_phone_bloc.dart';

sealed class EmailPhoneState extends Equatable {
  const EmailPhoneState();

  @override
  List<Object> get props => [];
}

final class EmailPhoneInitial extends EmailPhoneState {}

final class EmailMode extends EmailPhoneState {
  const EmailMode(this.email);

  final String email;

  @override
  List<String> get props => [email];
}

final class PhoneMode extends EmailPhoneState {
  const PhoneMode(this.phone);

  final String phone;

  @override
  List<String> get props => [phone];
}

final class InvalidEmail extends EmailPhoneState {
  const InvalidEmail(this.emailError);

  final String emailError;

  @override
  List<Object> get props => [emailError];
}

final class InvalidPhone extends EmailPhoneState {
  const InvalidPhone(this.phoneError);

  final String phoneError;

  @override
  List<Object> get props => [phoneError];
}

final class ConfirmedEmailOrPhone extends EmailPhoneState {}

final class EmailPhoneError extends EmailPhoneState {
  const EmailPhoneError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
