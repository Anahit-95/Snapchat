import 'package:snapchat/core/models/country_model.dart';

abstract class ApiRepo {
  Future<List<CountryModel>> loadCountries();
}
