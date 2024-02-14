import 'package:realm/realm.dart';
import 'package:snapchat/core/common/repositories/countries_db_repository/countries_db_repo.dart';
import 'package:snapchat/core/database/realm_db_helper.dart';
import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/core/realm_models/country.dart';

class CountriesRealmRepoImpl implements CountriesDBRepo {
  CountriesRealmRepoImpl(RealmDBHelper dbHelper) : _dbHelper = dbHelper;

  final RealmDBHelper _dbHelper;

  @override
  Future<List<CountryModel>> getCountries() async {
    print('Im here');
    final countriesDB = _dbHelper.realm.all<Country>();
    final countries = <CountryModel>[];
    for (final country in countriesDB) {
      countries.add(CountryModel(
        phoneCode: country.phoneCode,
        countryCode: country.countryCode,
        countryName: country.countryName,
        example: country.example,
      ));
    }
    return countries;
  }

  @override
  Future<CountryModel?> getCountryByCode(String countryCode) async {
    final countriesDB = _dbHelper.realm
        .all<Country>()
        .query(r'countryCode == $0', [countryCode]);
    if (countriesDB.isNotEmpty) {
      final country = countriesDB[0];
      return CountryModel(
        phoneCode: country.phoneCode,
        countryCode: country.countryCode,
        countryName: country.countryName,
        example: country.example,
      );
    }
    return null;
  }

  @override
  Future<void> insertCountries(List<CountryModel> countries) async {
    final countryList = <Country>[];
    for (final country in countries) {
      countryList.add(Country(
        country.phoneCode,
        country.countryCode,
        country.countryName,
        country.example,
      ));
    }
    _dbHelper.realm.write(() {
      _dbHelper.realm.addAll(countryList);
    });
  }
}
