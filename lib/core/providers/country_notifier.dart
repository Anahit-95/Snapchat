import 'dart:convert';

import 'package:country_codes/country_codes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/core/models/country_model.dart';

class CountryNotifier extends ChangeNotifier {
  CountryModel? _country;

  CountryModel? get country => _country!;

  Future<void> getCountry([String? countryCode]) async {
    String code;
    if (countryCode == null) {
      final locale = CountryCodes.getDeviceLocale()!;
      code = locale.countryCode!;
    } else {
      code = countryCode;
    }
    final data =
        await rootBundle.loadString('assets/resources/country_codes.json');
    final List<dynamic> jsonList = jsonDecode(data);

    final countries =
        jsonList.map((json) => CountryModel.fromMap(json)).toList();
    _country = countries.firstWhere((country) => country.countryCode == code);
    notifyListeners();
  }

  void setCountry(CountryModel newCountry) {
    _country = newCountry;
    notifyListeners();
  }
}
