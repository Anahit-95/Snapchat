import 'package:realm/realm.dart';
part 'country.g.dart';

@RealmModel()
class _Country {
  late String phoneCode;
  late String countryCode;
  late String countryName;
  late String example;
}
