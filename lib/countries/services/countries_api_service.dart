import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:snapchat/core/models/country_model.dart';

class CountriesApiService {
  CountriesApiService(this._client);

  final http.Client _client;
  static const _baseUrl =
      'https://drive.usercontent.google.com/download?id=1etEvdFNddpFfd5tQ-bYObtKsti7kbiu3';

  Future<List<CountryModel>> getCountriesApi() async {
    try {
      final response = await _client.get(Uri.parse(_baseUrl));
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
