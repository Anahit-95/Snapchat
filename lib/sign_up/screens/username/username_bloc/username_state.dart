part of 'username_bloc.dart';

sealed class UsernameState extends Equatable {
  const UsernameState();

  @override
  List<Object> get props => [];
}

final class UsernameInitial extends UsernameState {}

final class InvalidUsername extends UsernameState {
  const InvalidUsername(this.usernameError);

  final String usernameError;

  @override
  List<Object> get props => [usernameError];
}

final class UsernameAvailable extends UsernameState {}

final class UsernameLoading extends UsernameState {}

final class UsernameConfirmed extends UsernameState {}

final class UsernameError extends UsernameState {
  const UsernameError(this.error);

  final String error;

  @override
  List<String> get props => [error];
}
