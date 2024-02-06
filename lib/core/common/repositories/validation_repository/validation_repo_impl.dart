import 'package:snapchat/core/common/repositories/validation_repository/validation_repo.dart';
import 'package:snapchat/core/models/user_model.dart';

class ValidationRepoImpl implements ValidatonRepo {
  @override
  bool isValidUsername(String name) {
    if (name.length < 5 && name.isNotEmpty) {
      return false;
    }
    return true;
  }

  @override
  bool isValidUsernameAndNotEmpty(String username) {
    if (username.length >= 5) {
      return true;
    }
    return false;
  }

  @override
  bool isUsernameAvailable(
      {required String username, required List<UserModel> allUsers}) {
    final existingUsername =
        allUsers.where((user) => user.username == username);
    if (existingUsername.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool isValidBirthday(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final years = difference.inDays ~/ 365;
    if (years < 16) {
      return false;
    }
    return true;
  }

  @override
  bool isValidEmail(String email) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    if (regex.hasMatch(email)) {
      return true;
    }
    return false;
  }

  @override
  bool isEmailAvailable(
      {required String email, required List<UserModel> allUsers}) {
    final existingEmail = allUsers.where((user) => user.email == email);
    if (existingEmail.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool isValidPassword(String password) {
    if (password.length < 8 && password.isNotEmpty) {
      return false;
    }
    return true;
  }

  @override
  bool isValidPasswordAndNotEmpty(String password) {
    if (password.length >= 8) {
      return true;
    }
    return false;
  }

  @override
  bool isValidPhoneNumber(String phoneNumber) {
    if (phoneNumber.isNotEmpty && int.tryParse(phoneNumber) != null) {
      return true;
    }
    return false;
  }

  @override
  bool isPhoneNumberAvailable(
      {required String phoneCode,
      required String phoneNumber,
      required List<UserModel> allUsers}) {
    final existingPhone = allUsers.where((user) =>
        user.phoneNumber == phoneNumber && user.phoneCode == phoneCode);
    if (existingPhone.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool isValidLoginState({required email, required password}) {
    if (email.length >= 5 && password.length >= 8) {
      return true;
    }
    return false;
  }

  @override
  bool isValidNameState({required firstName, required lastName}) {
    if (firstName.isEmpty || lastName.isEmpty) {
      return false;
    }
    return true;
  }
}
