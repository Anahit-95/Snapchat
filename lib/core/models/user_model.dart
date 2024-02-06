import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.username,
    required this.password,
    this.email,
    this.countryCode,
    this.phoneCode,
    this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      birthday: DateTime.parse(map['birthday']),
      username: map['username'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      countryCode:
          map['countryCode'] != null ? map['countryCode'] as String : null,
      phoneCode: map['phoneCode'] != null ? map['phoneCode'] as String : null,
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
  final String? countryCode;
  final String? phoneCode;
  final String? phoneNumber;
  final String password;

  UserModel copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? username,
    String? email,
    String? countryCode,
    String? phoneCode,
    String? phoneNumber,
    String? password,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      username: username ?? this.username,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      phoneCode: phoneCode ?? this.phoneCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday.toIso8601String(),
      'username': username,
      'email': email,
      'countryCode': countryCode,
      'phoneCode': phoneCode,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [
        username,
        firstName,
        lastName,
        birthday,
        email,
        countryCode,
        phoneCode,
        phoneNumber,
        password,
      ];

  @override
  bool get stringify => true;
}
