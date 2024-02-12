import 'package:snapchat/core/common/repositories/countries_db_repository/countries_db_repo.dart';
import 'package:snapchat/core/database/database_helper.dart';
import 'package:snapchat/core/models/country_model.dart';
import 'package:sqflite/sqflite.dart';

class CountriesDBRepoImpl implements CountriesDBRepo {
  CountriesDBRepoImpl(DatabaseHelper dbHelper) : _dbHelper = dbHelper;

  final DatabaseHelper _dbHelper;
  @override
  Future<void> insertCountries(List<CountryModel> countries) async {
    final db = await _dbHelper.database;
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
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query('Countries');
    final countries = result.map((map) => CountryModel.fromMapDB(map)).toList();
    return countries;
  }

  @override
  Future<CountryModel?> getCountryByCode(String countryCode) async {
    final db = await _dbHelper.database;
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
}
