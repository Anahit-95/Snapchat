import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.username,
    this.email,
    this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      birthday: DateTime.fromMillisecondsSinceEpoch(map['birthday'] as int),
      username: map['username'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  final String uid;
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String username;
  final String? email;
  final String? phoneNumber;

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? username,
    String? email,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday.millisecondsSinceEpoch,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [uid, username];
}
