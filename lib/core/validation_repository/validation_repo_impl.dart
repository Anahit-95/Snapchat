import 'package:snapchat/core/validation_repository/validation_repo.dart';

class ValidationRepoImpl implements ValidatonRepo {
  @override
  bool isValidBirthday(DateTime date) {
    // TODO: implement isValidBirthday
    throw UnimplementedError();
  }

  @override
  bool isValidEmail(String email) {
    // TODO: implement isValidEmail
    throw UnimplementedError();
  }

  @override
  bool isValidPassword(String password) {
    if (password.length < 8 && password.isNotEmpty) {
      return false;
    }
    return true;
  }

  @override
  bool isValidPhoneNumber(String phoneNumber) {
    // TODO: implement isValidPhoneNumber
    throw UnimplementedError();
  }

  @override
  bool isValidUsername(String name) {
    if (name.length < 5 && name.isNotEmpty) {
      return false;
    }
    return true;
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
