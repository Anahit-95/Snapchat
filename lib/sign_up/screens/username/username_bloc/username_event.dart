part of 'username_bloc.dart';

sealed class UsernameEvent extends Equatable {
  const UsernameEvent();

  @override
  List<Object> get props => [];
}

final class OnChangeInputEvent extends UsernameEvent {
  const OnChangeInputEvent(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

final class ConfirmingUsername extends UsernameEvent {
  const ConfirmingUsername(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}
