part of 'sign_up_email_phone_bloc.dart';

sealed class SignUpEmailPhoneEvent extends Equatable {
  const SignUpEmailPhoneEvent();

  @override
  List<Object> get props => [];
}

final class GetCountryEvent extends SignUpEmailPhoneEvent {
  const GetCountryEvent(this.countryCode);

  final String? countryCode;

  @override
  List<Object> get props => [countryCode!];
}

final class EmailOnChangeEvent extends SignUpEmailPhoneEvent {
  const EmailOnChangeEvent(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class PhoneOnChangeEvent extends SignUpEmailPhoneEvent {
  const PhoneOnChangeEvent(
      {required this.phoneNumber, required this.phoneCode});

  final String phoneNumber;
  final String phoneCode;

  @override
  List<Object> get props => [phoneCode, phoneNumber];
}
