import 'package:flutter/material.dart';
import 'package:snapchat/core/common/repositories/storage_repo/storage_repo_impl.dart';

class LocaleNotifier extends ChangeNotifier {
  LocaleNotifier({required StorageRepoImpl store}) : _store = store {
    _initLocale();
  }

  Future<void> _initLocale() async {
    final lCode = await _store.getLocale();
    if (lCode != null) {
      _appLocale = Locale(lCode);
    }
    print('App language is -$_appLocale');
    notifyListeners();
  }

  final StorageRepoImpl _store;
  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  void setLocale(Locale locale) {
    _appLocale = locale;
    _store.setLocale(locale.languageCode);
    notifyListeners();
  }
}
