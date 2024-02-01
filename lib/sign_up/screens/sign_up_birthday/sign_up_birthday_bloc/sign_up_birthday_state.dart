part of 'sign_up_birthday_bloc.dart';

sealed class SignUpBirthdayState extends Equatable {
  const SignUpBirthdayState();

  @override
  List<Object> get props => [];
}

final class BirthdayInitial extends SignUpBirthdayState {}

final class OpenDatePicker extends SignUpBirthdayState {}

final class BirthdaySelected extends SignUpBirthdayState {
  const BirthdaySelected(this.selectedDate);

  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate];
}

final class InvalidBirthday extends SignUpBirthdayState {}

final class ValidBirthday extends SignUpBirthdayState {}
