part of 'name_bloc.dart';

sealed class NameState extends Equatable {
  const NameState();

  @override
  List<Object> get props => [];
}

final class NameInitial extends NameState {}

final class NameLoading extends NameState {}

final class NameRegistered extends NameState {}

final class ButtonIsDisabled extends NameState {}

final class ButtonIsEnabled extends NameState {}

final class NameSignUpError extends NameState {
  const NameSignUpError(this.error);
  final String error;

  @override
  List<String> get props => [error];
}
