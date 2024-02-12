part of 'sign_up_email_phone_bloc.dart';

sealed class SignUpEmailPhoneState extends Equatable {
  const SignUpEmailPhoneState();

  @override
  List<Object> get props => [];
}

final class EmailPhoneInitial extends SignUpEmailPhoneState {}

final class FindingCountry extends SignUpEmailPhoneState {}

final class CountryFounded extends SignUpEmailPhoneState {
  const CountryFounded({
    required this.country,
    required this.countries,
  });

  final CountryModel country;
  final List<CountryModel> countries;

  @override
  List<Object> get props => [country];
}

final class EmailMode extends SignUpEmailPhoneState {
  const EmailMode(this.email);

  final String email;

  @override
  List<String> get props => [email];
}

final class PhoneMode extends SignUpEmailPhoneState {
  const PhoneMode(this.phone);

  final String phone;

  @override
  List<String> get props => [phone];
}

final class InvalidEmail extends SignUpEmailPhoneState {
  const InvalidEmail(this.emailError);

  final String emailError;

  @override
  List<Object> get props => [emailError];
}

final class InvalidPhone extends SignUpEmailPhoneState {
  const InvalidPhone(this.phoneError);

  final String phoneError;

  @override
  List<Object> get props => [phoneError];
}
