part of 'sign_up_birthday_bloc.dart';

sealed class SignUpBirthdayEvent extends Equatable {
  const SignUpBirthdayEvent();

  @override
  List<Object> get props => [];
}

final class SelectingDate extends SignUpBirthdayEvent {
  const SelectingDate(this.birthDate);

  final DateTime birthDate;

  @override
  List<Object> get props => [birthDate];
}

final class ConfirmingDate extends SignUpBirthdayEvent {
  const ConfirmingDate(this.birthDate);

  final DateTime birthDate;

  @override
  List<Object> get props => [birthDate];
}
