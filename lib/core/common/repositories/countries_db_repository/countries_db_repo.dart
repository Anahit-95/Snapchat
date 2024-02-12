import 'package:snapchat/core/models/country_model.dart';

abstract class CountriesDBRepo {
  Future<void> insertCountries(List<CountryModel> countries);

  Future<List<CountryModel>> getCountries();

  Future<CountryModel?> getCountryByCode(String countryCode);
}
