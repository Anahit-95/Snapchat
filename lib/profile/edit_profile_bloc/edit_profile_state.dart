part of 'edit_profile_bloc.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

final class EditProfileInitial extends EditProfileState {}

final class InvalidEditState extends EditProfileState {
  const InvalidEditState({
    required this.firstNameError,
    required this.lastNameError,
    required this.birthdayError,
    required this.usernameError,
    required this.emailError,
    required this.phoneError,
    required this.passwordError,
  });

  final String firstNameError;
  final String lastNameError;
  final String birthdayError;
  final String usernameError;
  final String emailError;
  final String phoneError;
  final String passwordError;

  @override
  List<Object> get props => [
        firstNameError,
        lastNameError,
        birthdayError,
        usernameError,
        emailError,
        phoneError,
        passwordError,
      ];
}

final class FindingCountry extends EditProfileState {}

final class CountryFounded extends EditProfileState {
  const CountryFounded(this.country);

  final CountryModel country;

  @override
  List<Object> get props => [country];
}

final class ValidEditState extends EditProfileState {}

final class LoadingEditProfile extends EditProfileState {}

final class UpdatedProfile extends EditProfileState {}

final class LogOutState extends EditProfileState {}
