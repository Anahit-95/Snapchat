import 'package:snapchat/core/common/repositories/api_repository/api_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_db_repository/countries_db_repo_impl.dart';
import 'package:snapchat/core/common/repositories/countries_repository/countries_repo.dart';
import 'package:snapchat/core/models/country_model.dart';

class CountriesRepoImpl implements CountriesRepo {
  CountriesRepoImpl({
    required ApiRepoImpl apiRepo,
    required CountriesDBRepoImpl dbRepo,
  })  : _apiRepo = apiRepo,
        _dbRepo = dbRepo;

  final ApiRepoImpl _apiRepo;
  final CountriesDBRepoImpl _dbRepo;

  @override
  Future<List<CountryModel>> loadCountries() async {
    try {
      var countries = await _dbRepo.getCountries();
      if (countries.isEmpty) {
        countries = await _apiRepo.loadCountries();
        print('loaded from api');
        await _dbRepo.insertCountries(countries);
        return countries;
      }
      print('loaded from db');
      return countries;
    } catch (e) {
      throw Exception('Failed loading countries.');
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
