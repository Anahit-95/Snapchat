import 'package:realm/realm.dart';
import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/database/realm_db_helper.dart';
import 'package:snapchat/core/models/user_model.dart';
import 'package:snapchat/core/realm_models/user_m.dart';

class UserRealmRepoImpl implements UsersDBRepo {
  UserRealmRepoImpl(RealmDBHelper dbHelper) : _dbHelper = dbHelper;

  final RealmDBHelper _dbHelper;

  UserModel createUserModel(UserM user) {
    final userModel = UserModel()
      ..firstName = user.firstName
      ..lastName = user.lastName
      ..birthday = DateTime.parse(user.birthday!)
      ..username = user.username
      ..email = user.email
      ..countryCode = user.countryCode
      ..phoneCode = user.phoneCode
      ..phoneNumber = user.phoneNumber
      ..password = user.password;
    return userModel;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final usersDB = _dbHelper.realm.all<UserM>();
    final users = <UserModel>[];
    for (final user in usersDB) {
      final userModel = createUserModel(user);

      users.add(userModel);
    }
    return users;
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final usersDB = _dbHelper.realm.all<UserM>().query(r'email == $0', [email]);
    if (usersDB.isNotEmpty) {
      return createUserModel(usersDB[0]);
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByPhone(
      String phoneCode, String phoneNumber) async {
    final usersDB = _dbHelper.realm.all<UserM>().query(
      r'phoneCode == $0 AND phoneNumber == $1',
      [phoneCode, phoneNumber],
    );
    if (usersDB.isNotEmpty) {
      return createUserModel(usersDB[0]);
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByUsername(String username) async {
    final usersDB =
        _dbHelper.realm.all<UserM>().query(r'username == $0', [username]);
    if (usersDB.isNotEmpty) {
      return createUserModel(usersDB[0]);
    }
    return null;
  }

  @override
  Future<void> insertUser(UserModel user) async {
    final userM = UserM(user.username)
      ..firstName = user.firstName
      ..lastName = user.lastName
      ..birthday = user.birthday?.toIso8601String()
      ..email = user.email
      ..countryCode = user.countryCode
      ..phoneCode = user.phoneCode
      ..phoneNumber = user.phoneNumber
      ..password = user.password;

    _dbHelper.realm.write(() {
      _dbHelper.realm.add(userM);
    });
  }

  @override
  Future<UserModel?> loginUser({
    required String password,
    required String text,
    required ValidationRepoImpl validationRepo,
  }) async {
    UserM userQuery;
    if (validationRepo.isValidEmail(text)) {
      userQuery = _dbHelper.realm.all<UserM>().query(
        r'email == $0 AND password == $1',
        [text, password],
      ).first;
    } else {
      userQuery = _dbHelper.realm.all<UserM>().query(
        r'username == $0 AND password == $1',
        [text, password],
      ).first;
    }
    return createUserModel(userQuery);
  }

  @override
  Future<void> updateUser({
    required String oldUsername,
    required UserModel updatedUser,
  }) async {
    final user = _dbHelper.realm.find<UserM>(oldUsername);
    if (oldUsername == updatedUser.username) {
      _dbHelper.realm.write(() {
        user!
          ..firstName = updatedUser.firstName
          ..lastName = updatedUser.lastName
          ..birthday = updatedUser.birthday!.toIso8601String()
          ..email = updatedUser.email
          ..countryCode = updatedUser.countryCode
          ..phoneCode = updatedUser.phoneCode
          ..phoneNumber = updatedUser.phoneNumber
          ..password = updatedUser.password;
      });
    } else {
      _dbHelper.realm.write(() {
        _dbHelper.realm.delete<UserM>(user!);
      });
      insertUser(updatedUser);
    }
  }
}
