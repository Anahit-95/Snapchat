import 'package:flutter/foundation.dart';
import 'package:snapchat/core/models/country_model.dart';

class CountryNotifier extends ChangeNotifier {
  CountryModel? _country;

  CountryModel? get country => _country;

  void setCountry(CountryModel newCountry) {
    _country = newCountry;
    notifyListeners();
  }
}
