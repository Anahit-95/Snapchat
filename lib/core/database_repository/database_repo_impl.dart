import 'package:snapchat/core/database_repository/database_repo.dart';
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
              lastName TEXT, 
              birthday TEXT, 
              username TEXT PRIMARY KEY,
              email TEXT,
              phoneNumber TEXT,
              password TEXT
            )
          ''');
      },
    );
  }

  @override
  Future<bool> countriesTableExist() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('Countries');
    if (result.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Future<void> insertCountries(List<CountryModel> countries) async {
    print('Inserting countries.');
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
    print('getCountries function');
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('Countries');
    final countries = result.map((map) => CountryModel.fromMapDB(map)).toList();
    return countries;
  }

  @override
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    final userId = await db.insert('Users', user.toMap());
    return userId;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('Users');
    final users = result.map((map) => UserModel.fromMap(map)).toList();
    return users;
  }

  @override
  Future<UserModel?> loginUser(
      {required String password, String? email, String? username}) async {
    final db = await database;
    List<Map<String, dynamic>> userMap;
    if (username == null) {
      userMap = await db.query('Users',
          where: 'email = ? AND password = ?', whereArgs: [email, password]);
    } else {
      userMap = await db.query('Users',
          where: 'username = ? AND password = ?', whereArgs: [email, password]);
    }
    if (userMap.isNotEmpty) {
      final user = UserModel.fromMap(userMap[0]);
      return user;
    }
    return null;
  }
}
