part of 'sign_up_username_bloc.dart';

sealed class SignUpUsernameEvent extends Equatable {
  const SignUpUsernameEvent();

  @override
  List<Object> get props => [];
}

final class OnChangeInputEvent extends SignUpUsernameEvent {
  const OnChangeInputEvent(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

// final class ConfirmingUsername extends SignUpUsernameEvent {
//   const ConfirmingUsername(this.username);

//   final String username;

//   @override
//   List<Object> get props => [username];
// }
