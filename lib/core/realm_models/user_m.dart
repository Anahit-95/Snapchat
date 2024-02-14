import 'package:realm/realm.dart';
part 'user_m.g.dart';

@RealmModel()
class _UserM {
  @PrimaryKey()
  String? username;

  String? firstName;
  String? lastName;
  String? birthday;
  String? email;
  String? countryCode;
  String? phoneCode;
  String? phoneNumber;
  String? password;
}
