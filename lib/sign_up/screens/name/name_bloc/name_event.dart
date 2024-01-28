part of 'name_bloc.dart';

sealed class NameEvent extends Equatable {
  const NameEvent();

  @override
  List<Object> get props => [];
}

class SignUpAndAcceptEvent extends NameEvent {
  const SignUpAndAcceptEvent({
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName];
}

class OnChangeInputEvent extends NameEvent {
  const OnChangeInputEvent({
    required this.firstName,
    required this.lastName,
  });
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName];
}
