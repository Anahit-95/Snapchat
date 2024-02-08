import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserModel extends Equatable {
  UserModel({
    this.firstName,
    this.lastName,
    this.birthday,
    this.username,
    this.password,
    this.email,
    this.countryCode,
    this.phoneCode,
    this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      birthday:
          map['birthday'] != null ? DateTime.parse(map['birthday']) : null,
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      countryCode:
          map['countryCode'] != null ? map['countryCode'] as String : null,
      phoneCode: map['phoneCode'] != null ? map['phoneCode'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
    );
  }

  String? firstName;
  String? lastName;
  DateTime? birthday;
  String? username;
  String? email;
  String? countryCode;
  String? phoneCode;
  String? phoneNumber;
  String? password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday?.toIso8601String(),
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
