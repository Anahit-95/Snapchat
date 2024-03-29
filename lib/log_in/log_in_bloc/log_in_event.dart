part of 'log_in_bloc.dart';

sealed class LogInEvent extends Equatable {
  const LogInEvent();

  @override
  List<Object> get props => [];
}

class LoggingInEvent extends LogInEvent {
  const LoggingInEvent({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class OnChangeInputEvent extends LogInEvent {
  const OnChangeInputEvent({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
