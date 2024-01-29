part of 'birthday_bloc.dart';

sealed class BirthdayEvent extends Equatable {
  const BirthdayEvent();

  @override
  List<Object> get props => [];
}

final class SelectingDate extends BirthdayEvent {
  const SelectingDate(this.birthDate);

  final DateTime? birthDate;

  @override
  List<Object> get props => [birthDate!];
}

final class ConfirmingDate extends BirthdayEvent {
  const ConfirmingDate(this.birthDate);

  final DateTime birthDate;

  @override
  List<Object> get props => [birthDate];
}
