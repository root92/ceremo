import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'locale';
  
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  String get languageCode => _locale.languageCode;
  
  bool get isEnglish => _locale.languageCode == 'en';
  bool get isFrench => _locale.languageCode == 'fr';
  
  // Initialize locale from storage
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey) ?? 'en';
    _locale = Locale(localeCode);
    notifyListeners();
  }
  
  // Set locale
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
  
  // Set specific language
  Future<void> setEnglish() async {
    await setLocale(const Locale('en'));
  }
  
  Future<void> setFrench() async {
    await setLocale(const Locale('fr'));
  }
  
  // Toggle between languages
  Future<void> toggleLanguage() async {
    if (isEnglish) {
      await setFrench();
    } else {
      await setEnglish();
    }
  }
  
  // Get language name for display
  String get languageName {
    switch (_locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }
  
  // Get language flag emoji
  String get languageFlag {
    switch (_locale.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      default:
        return '🇺🇸';
    }
  }
  
  // Get supported locales
  static List<Locale> get supportedLocales => [
    const Locale('en'),
    const Locale('fr'),
  ];
}
