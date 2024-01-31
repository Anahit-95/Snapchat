part of 'sign_up_password_bloc.dart';

sealed class SignUpPasswordEvent extends Equatable {
  const SignUpPasswordEvent();

  @override
  List<Object> get props => [];
}

final class OnChangePasswordInputEvent extends SignUpPasswordEvent {
  const OnChangePasswordInputEvent(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class ConfirmingPasswordEvent extends SignUpPasswordEvent {
  const ConfirmingPasswordEvent(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}
