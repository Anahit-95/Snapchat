part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

final class GetCountryEvent extends EditProfileEvent {
  const GetCountryEvent(this.countryCode);

  final String? countryCode;

  @override
  List<Object> get props => [countryCode!];
}

final class EditingOnChangeEvent extends EditProfileEvent {
  const EditingOnChangeEvent({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.username,
    required this.password,
    required this.user,
    this.email,
    this.phoneCode,
    this.phoneNumber,
  });

  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String username;
  final String? email;
  final String? phoneCode;
  final String? phoneNumber;
  final String password;
  final UserModel user;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        birthday,
        username,
        email!,
        phoneNumber!,
        password,
      ];
}

final class SaveProfileChanges extends EditProfileEvent {
  const SaveProfileChanges({required this.user, required this.username});

  final UserModel user;
  final String username;

  @override
  List<Object> get props => [username, user];
}
