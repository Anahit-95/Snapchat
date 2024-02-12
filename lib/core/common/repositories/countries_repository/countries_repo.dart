import 'package:snapchat/core/models/country_model.dart';

abstract class CountriesRepo {
  Future<List<CountryModel>> loadCountries();

  List<CountryModel> searchCountries({
    required String countryName,
    required List<CountryModel> countries,
  });
}
