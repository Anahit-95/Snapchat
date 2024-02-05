part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
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
    this.phone,
  });

  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String username;
  final String? email;
  final String? phone;
  final String password;
  final UserModel user;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        birthday,
        username,
        email!,
        phone!,
        password,
      ];
}

final class SaveProfileChanges extends EditProfileEvent {
  const SaveProfileChanges(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}
