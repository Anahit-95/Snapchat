import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   DatabaseHelper.internal();
//   factory DatabaseHelper() => _instance;

//   static final DatabaseHelper _instance = DatabaseHelper.internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }

//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     final databasesPath = await getDatabasesPath();
//     final path = '$databasesPath/snapchat_db.db';

//     // Open the database
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         // Create tables and perform initial setup
//         await db.execute('''CREATE TABLE IF NOT EXISTS Countries (
//               phoneCode TEXT,
//               countryCode TEXT PRIMARY KEY,
//               countryName TEXT,
//               example TEXT
//               )
//             ''');
//         await db.execute('''CREATE TABLE IF NOT EXISTS Users (
//               firstName TEXT,
//               lastName TEXT,
//               birthday TEXT,
//               username TEXT PRIMARY KEY,
//               email TEXT,
//               countryCode TEXT,
//               phoneCode TEXT,
//               phoneNumber TEXT,
//               password TEXT
//             )
//           ''');
//       },
//     );
//   }
// }

class DatabaseHelper {
  DatabaseHelper() : _database = _initDatabase();

  final Future<Database> _database;

  Future<Database> get database => _database;

  static Future<Database> _initDatabase() async {
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
}
