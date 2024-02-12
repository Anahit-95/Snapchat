import 'package:snapchat/core/common/repositories/users_db_repository/users_db_repo.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/database/database_helper.dart';
import 'package:snapchat/core/models/user_model.dart';

class UsersDBRepoImpl implements UsersDBRepo {
  UsersDBRepoImpl(DatabaseHelper dbHelper) : _dbHelper = dbHelper;

  final DatabaseHelper _dbHelper;

  @override
  Future<void> insertUser(UserModel user) async {
    final db = await _dbHelper.database;

    await db.insert('Users', user.toMap());
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query('Users');
    final users = result.map((map) => UserModel().fromMap(map)).toList();
    return users;
  }

  @override
  Future<UserModel?> loginUser({
    required String password,
    required String text,
    required ValidationRepoImpl validationRepo,
  }) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> userMap;
    if (validationRepo.isValidEmail(text)) {
      userMap = await db.query(
        'Users',
        where: 'email = ? AND password = ?',
        whereArgs: [text, password],
      );
    } else {
      userMap = await db.query(
        'Users',
        where: 'username = ? AND password = ?',
        whereArgs: [text, password],
      );
    }
    if (userMap.isNotEmpty) {
      final user = UserModel().fromMap(userMap[0]);
      return user;
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByUsername(String username) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> usersData;
    usersData = await db.query(
      'Users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (usersData.isNotEmpty) {
      return UserModel().fromMap(usersData[0]);
    }
    return null;
  }

  @override
  Future<void> updateUser(
      {required String oldUsername, required UserModel updatedUser}) async {
    final db = await _dbHelper.database;
    await db.update(
      'Users',
      updatedUser.toMap(),
      where: 'username = ?',
      whereArgs: [oldUsername],
    );
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> usersData;
    usersData = await db.query(
      'Users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (usersData.isNotEmpty) {
      return UserModel().fromMap(usersData[0]);
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByPhone(
      String phoneCode, String phoneNumber) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> usersData;
    usersData = await db.query('Users',
        where: 'phoneCode = ? AND phoneNumber = ?',
        whereArgs: [phoneCode, phoneNumber]);
    if (usersData.isNotEmpty) {
      return UserModel().fromMap(usersData[0]);
    }
    return null;
  }
}
