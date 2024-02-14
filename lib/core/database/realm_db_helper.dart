import 'package:realm/realm.dart';
import 'package:snapchat/core/realm_models/country.dart';
import 'package:snapchat/core/realm_models/user_m.dart';

class RealmDBHelper {
  RealmDBHelper() {
    final config = Configuration.local([Country.schema, UserM.schema]);
    realm = Realm(config);
  }

  late Realm realm;
}
