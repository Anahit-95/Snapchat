part of 'birthday_bloc.dart';

sealed class BirthdayState extends Equatable {
  const BirthdayState();

  @override
  List<Object> get props => [];
}

final class BirthdayInitial extends BirthdayState {}

final class BirthdaySelected extends BirthdayState {
  const BirthdaySelected(this.selectedDate);

  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate];
}

final class LoadingBirthday extends BirthdayState {}

final class InvalidBirthday extends BirthdayState {}

final class BirthdayConfirmed extends BirthdayState {}

final class BirthdayError extends BirthdayState {
  const BirthdayError(this.error);

  final String error;

  @override
  List<String> get props => [error];
}
