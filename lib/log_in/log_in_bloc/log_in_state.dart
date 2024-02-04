part of 'log_in_bloc.dart';

sealed class LogInState extends Equatable {
  const LogInState();

  @override
  List<Object> get props => [];
}

final class LogInInitial extends LogInState {}

final class LogInInvalidState extends LogInState {
  const LogInInvalidState({
    required this.emailError,
    required this.passwordError,
  });
  final String emailError;
  final String passwordError;

  @override
  List<Object> get props => [emailError, passwordError];
}

final class LoginValidState extends LogInState {}

final class LoggingIn extends LogInState {}

final class LogInSuccess extends LogInState {
  const LogInSuccess({required this.user});

  final UserModel user;

  @override
  List<Object> get props => [user];
}

final class LogInError extends LogInState {
  const LogInError(this.error);
  final String error;

  @override
  List<String> get props => [error];
}
