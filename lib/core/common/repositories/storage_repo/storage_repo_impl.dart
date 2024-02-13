import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo.dart';

class StorageRepoImpl extends StorageRepo {
  @override
  Future<void> setUser({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  @override
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs
      ..remove('username')
      ..remove('password');
  }

  @override
  Future<Map<String, String>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
    if (username.isNotEmpty && password.isNotEmpty) {
      return {'username': username, 'password': password};
    } else {
      return null;
    }
  }

  @override
  Future<String?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    return languageCode;
  }

  @override
  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
}
