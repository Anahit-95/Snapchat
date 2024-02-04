import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/core/models/user_model.dart';

abstract class DatabaseRepo {
  Future<bool> countriesTableExist();

  Future<void> insertCountries(List<CountryModel> countries);

  Future<List<CountryModel>> getCountries();

  Future<int> insertUser(UserModel user);

  Future<List<UserModel>> getAllUsers();

  Future<UserModel> getUserByUsername(String username);

  Future<UserModel?> loginUser({
    required String password,
    required String text,
    required bool isEmail,
  });
}
