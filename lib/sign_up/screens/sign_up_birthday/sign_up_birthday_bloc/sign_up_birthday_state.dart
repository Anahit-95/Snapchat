part of 'sign_up_birthday_bloc.dart';

sealed class SignUpBirthdayState extends Equatable {
  const SignUpBirthdayState();

  @override
  List<Object> get props => [];
}

final class BirthdayInitial extends SignUpBirthdayState {}

final class BirthdaySelected extends SignUpBirthdayState {
  const BirthdaySelected(this.selectedDate);

  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate];
}

final class InvalidBirthday extends SignUpBirthdayState {}

final class ValidBirthday extends SignUpBirthdayState {}

// final class LoadingBirthday extends SignUpBirthdayState {}

// final class BirthdayConfirmed extends SignUpBirthdayState {}

// final class BirthdayError extends SignUpBirthdayState {
//   const BirthdayError(this.error);

//   final String error;

//   @override
//   List<String> get props => [error];
// }
