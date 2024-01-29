part of 'sign_up_name_bloc.dart';

sealed class SignUpNameEvent extends Equatable {
  const SignUpNameEvent();

  @override
  List<Object> get props => [];
}

class SignUpAndAcceptEvent extends SignUpNameEvent {
  const SignUpAndAcceptEvent({
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName];
}

class OnChangeInputEvent extends SignUpNameEvent {
  const OnChangeInputEvent({
    required this.firstName,
    required this.lastName,
  });
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName];
}
