import 'package:flutter/foundation.dart';
import 'package:snapchat/core/models/country_model.dart';

class CountryValueNotifier extends ValueNotifier<CountryModel?> {
  CountryValueNotifier() : super(null);

  void setCountry(CountryModel? country) {
    value = country;
  }
}
