part of 'sign_up_name_bloc.dart';

sealed class SignUpNameState extends Equatable {
  const SignUpNameState();

  @override
  List<Object> get props => [];
}

final class NameInitial extends SignUpNameState {}

// final class NameLoading extends SignUpNameState {}

// final class NameRegistered extends SignUpNameState {}

final class ButtonIsDisabled extends SignUpNameState {}

final class ButtonIsEnabled extends SignUpNameState {}

final class NameSignUpError extends SignUpNameState {
  const NameSignUpError(this.error);
  final String error;

  @override
  List<String> get props => [error];
}
