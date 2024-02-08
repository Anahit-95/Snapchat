import 'package:snapchat/core/common/repositories/database_repository/database_repo.dart';
import 'package:snapchat/core/common/repositories/validation_repository/validation_repo_impl.dart';
import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/core/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRepoImpl implements DatabaseRepo {
  DatabaseRepoImpl.internal();
  factory DatabaseRepoImpl() => _instance;

  static final DatabaseRepoImpl _instance = DatabaseRepoImpl.internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = '$databasesPath/snapchat_db.db';

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create tables and perform initial setup
        await db.execute('''CREATE TABLE IF NOT EXISTS Countries (
              phoneCode TEXT, 
              countryCode TEXT PRIMARY KEY, 
              countryName TEXT, 
              example TEXT
              )
            ''');
        await db.execute('''CREATE TABLE IF NOT EXISTS Users (
              firstName TEXT,
              lastName TEXT, 
              birthday TEXT, 
              username TEXT PRIMARY KEY,
              email TEXT,
              countryCode TEXT,
              phoneCode TEXT,
              phoneNumber TEXT,
              password TEXT
            )
          ''');
      },
    );
  }

  // @override
  // Future<bool> countriesTableExist() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> result = await db.query('Countries');
  //   if (result.isEmpty) {
  //     return false;
  //   }
  //   return true;
  // }

  @override
  Future<void> insertCountries(List<CountryModel> countries) async {
    final db = await database;
    final batch = db.batch();
    for (final country in countries) {
      batch.insert(
        'Countries',
        country.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('Countries');
    final countries = result.map((map) => CountryModel.fromMapDB(map)).toList();
    return countries;
  }

  @override
  Future<CountryModel?> getCountryByCode(String countryCode) async {
    final db = await database;
    final countryMap = await db.query(
      'Countries',
      where: 'countryCode = ?',
      whereArgs: [countryCode],
    );
    if (countryMap.isNotEmpty) {
      return CountryModel.fromMapDB(countryMap[0]);
    }
    return null;
  }

  @override
  Future<void> insertUser(UserModel user) async {
    final db = await database;

    await db.insert('Users', user.toMap());
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('Users');
    final users = result.map((map) => UserModel.fromMap(map)).toList();
    return users;
  }

  @override
  Future<UserModel?> loginUser({
    required String password,
    required String text,
    required ValidationRepoImpl validationRepo,
  }) async {
    final db = await database;
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
      final user = UserModel.fromMap(userMap[0]);
      return user;
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByUsername(String username) async {
    final db = await database;
    List<Map<String, dynamic>> usersData;
    usersData = await db.query(
      'Users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (usersData.isNotEmpty) {
      return UserModel.fromMap(usersData[0]);
    }
    return null;
  }

  @override
  Future<void> updateUser(
      {required String oldUsername, required UserModel updatedUser}) async {
    final db = await database;
    await db.update(
      'Users',
      updatedUser.toMap(),
      where: 'username = ?',
      whereArgs: [oldUsername],
    );
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> usersData;
    usersData = await db.query(
      'Users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (usersData.isNotEmpty) {
      return UserModel.fromMap(usersData[0]);
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByPhone(
      String phoneCode, String phoneNumber) async {
    final db = await database;
    List<Map<String, dynamic>> usersData;
    usersData = await db.query('Users',
        where: 'phoneCode = ? AND phoneNumber = ?',
        whereArgs: [phoneCode, phoneNumber]);
    if (usersData.isNotEmpty) {
      return UserModel.fromMap(usersData[0]);
    }
    return null;
  }
}
