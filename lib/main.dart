import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:snapchat/home/navigation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CountryCodes.init();

  runApp(const Home());
}
