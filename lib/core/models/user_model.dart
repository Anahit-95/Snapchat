// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.username,
    required this.password,
    this.email,
    this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      birthday: DateTime.parse(map['birthday']),
      username: map['username'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      password: map['password'] as String,
    );
  }

  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String username;
  final String? email;
  final String? phoneNumber;
  final String password;

  UserModel copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? username,
    String? email,
    String? phoneNumber,
    String? password,
  }) {
    return UserModel(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        birthday: birthday ?? this.birthday,
        username: username ?? this.username,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday.toIso8601String(),
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password
    };
  }

  @override
  List<Object?> get props => [username, email, phoneNumber];

  @override
  bool get stringify => true;
}
