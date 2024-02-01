import 'package:snapchat/core/models/country_model.dart';

abstract class LoadCountriesRepo {
  Future<List<CountryModel>> loadCountries();
}
