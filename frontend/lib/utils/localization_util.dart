import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocaleProvider extends ChangeNotifier {
  Locale _locale = Settings.isInitialized ? Locale(Settings.getValue("language_key", defaultValue: LocaleProvider.allSupportedLocales[0].languageCode)!, "") : LocaleProvider.allSupportedLocales[0];
  Future<SharedPreferences> setupLocale () async {
    final prefs = await SharedPreferences.getInstance();

    return prefs;
  }

  static final List<Locale> allSupportedLocales = [
    const Locale('de'), // German, no country code
    const Locale('en'), // English, no country code
  ];

  static String? getLocaleFlag(String localeCode) {
    switch (localeCode) {
      case 'en':
        return '🇩🇪';
      case 'de':
        return '🇬🇧';
      default:
        return null;
    }
  }

  Locale get locale => _locale;

  set locale(Locale newLocale) {
    if (!allSupportedLocales.contains(newLocale)) return;

    _locale = newLocale;
    notifyListeners();
  }

/*
  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
*/
}
