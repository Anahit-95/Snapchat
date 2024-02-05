part of 'sign_up_password_bloc.dart';

sealed class SignUpPasswordState extends Equatable {
  const SignUpPasswordState();

  @override
  List<Object> get props => [];
}

final class PasswordInitial extends SignUpPasswordState {}

final class LoadingPassword extends SignUpPasswordState {}

final class ValidPassword extends SignUpPasswordState {}

final class InvalidPassword extends SignUpPasswordState {
  const InvalidPassword(this.passwordError);

  final String passwordError;

  @override
  List<Object> get props => [passwordError];
}

final class ConfirmPassword extends SignUpPasswordState {}

final class SignUpError extends SignUpPasswordState {
  const SignUpError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
