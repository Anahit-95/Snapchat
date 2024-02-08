import 'package:snapchat/core/common/repositories/api_repository/api_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_repository/countries_repo.dart';
import 'package:snapchat/core/common/repositories/database_repository/database_repo_impl.dart';
import 'package:snapchat/core/models/country_model.dart';

class CountriesRepoImpl implements CountriesRepo {
  CountriesRepoImpl({
    required ApiRepoImpl apiRepo,
    required DatabaseRepoImpl dbRepo,
  })  : _apiRepo = apiRepo,
        _dbRepo = dbRepo;

  final ApiRepoImpl _apiRepo;
  final DatabaseRepoImpl _dbRepo;

  @override
  Future<CountryModel> getCountry(String countryCode) {
    // TODO: implement getCountry
    throw UnimplementedError();
  }

  @override
  Future<List<CountryModel>> loadCountries() async {
    final databaseExists = await _dbRepo.countriesTableExist();
    List<CountryModel> countries;
    if (databaseExists) {
      try {
        countries = await _dbRepo.getCountries();
        print('loaded from database');
        return countries;
      } catch (e) {
        throw Exception('Failed loading countries from database.');
      }
    } else {
      try {
        countries = await _apiRepo.loadCountries();
        print('loaded from api');
        await _dbRepo.insertCountries(countries);
        return countries;
      } catch (e) {
        throw Exception('Failed loading countries.');
      }
    }
  }

  @override
  List<CountryModel> searchCountries(
      {required String countryName, required List<CountryModel> countries}) {
    final findedCountries = countries
        .where(
          (country) =>
              country.countryName
                  .toLowerCase()
                  .contains(countryName.toLowerCase()) ||
              country.countryCode
                  .toLowerCase()
                  .contains(countryName.toLowerCase()) ||
              country.phoneCode.contains(countryName.toLowerCase()),
        )
        .toList();
    return findedCountries;
  }
}
