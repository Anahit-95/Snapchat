part of 'sign_up_username_bloc.dart';

sealed class SignUpUsernameState extends Equatable {
  const SignUpUsernameState();

  @override
  List<Object> get props => [];
}

final class UsernameInitial extends SignUpUsernameState {}

final class InvalidUsername extends SignUpUsernameState {
  const InvalidUsername(this.usernameError);

  final String usernameError;

  @override
  List<Object> get props => [usernameError];
}

final class UsernameAvailable extends SignUpUsernameState {}
