import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

const String globalLangKey = "global.";

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Settings.isInitialized ? Locale(Settings.getValue("language_key", LocaleProvider.allSupportedLocales[0].languageCode), "") : LocaleProvider.allSupportedLocales[0];

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
