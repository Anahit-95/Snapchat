import 'package:snapchat/core/models/user_model.dart';

abstract class ValidatonRepo {
  bool isValidUsername(String name);

  bool isValidUsernameAndNotEmpty(String username);

  bool isUsernameAvailable(
      {required String username, required List<UserModel> allUsers});

  bool isValidPassword(String password);

  bool isValidPasswordAndNotEmpty(String password);

  bool isValidEmail(String email);

  bool isEmailAvailable(
      {required String email, required List<UserModel> allUsers});

  bool isValidBirthday(DateTime date);

  bool isValidPhoneNumber(String phoneNumber);

  bool isPhoneNumberAvailable(
      {required String phoneNumber, required List<UserModel> allUsers});

  bool isValidNameState({required firstName, required lastName});

  bool isValidLoginState({required email, required password});
}
