part of 'sign_up_email_phone_bloc.dart';

sealed class SignUpEmailPhoneEvent extends Equatable {
  const SignUpEmailPhoneEvent();

  @override
  List<Object> get props => [];
}

final class EmailOnChangeEvent extends SignUpEmailPhoneEvent {
  const EmailOnChangeEvent(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class PhoneOnChangeEvent extends SignUpEmailPhoneEvent {
  const PhoneOnChangeEvent(this.phone);

  final String phone;

  @override
  List<Object> get props => [phone];
}

// final class ConfirmEmailOrPhoneEvent extends SignUpEmailPhoneEvent {
//   const ConfirmEmailOrPhoneEvent({this.email, this.phone});

//   final String? email;
//   final String? phone;

//   @override
//   List<Object> get props => [email!, phone!];
// }
