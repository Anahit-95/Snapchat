abstract class ValidatonRepo {
  bool isValidUsername(String name);

  bool isValidPassword(String password);

  bool isValidEmail(String email);

  bool isValidBirthday(DateTime date);

  bool isValidPhoneNumber(String phoneNumber);

  bool isValidNameState({required firstName, required lastName});

  bool isValidLoginState({required email, required password});
}
