import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:snapchat/core/models/country_model.dart';
import 'package:snapchat/countries/repository/load_countries_repo.dart';

class LoadCountriesRepoImpl implements LoadCountriesRepo {
  static const _baseUrl =
      'https://drive.usercontent.google.com/download?id=1etEvdFNddpFfd5tQ-bYObtKsti7kbiu3';

  @override
  Future<List<CountryModel>> loadCountries() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      final List<dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      final countries =
          jsonResponse.map((json) => CountryModel.fromMap(json)).toList();
      return countries;
    } catch (e) {
      rethrow;
    }
  }
}
