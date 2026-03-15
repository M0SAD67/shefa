import 'package:flutter/material.dart';
import '../cache/cache_helper.dart';

class AppStateManager extends ChangeNotifier {
  // Singleton pattern for easy access if needed,
  // though using it via Provider/ListenableBuilder is better.
  static final AppStateManager _instance = AppStateManager._internal();
  factory AppStateManager() => _instance;
  AppStateManager._internal();

  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ar');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isArabic => _locale.languageCode == 'ar';

  static const String _themeKey = 'themeMode';
  static const String _langKey = 'languageCode';

  void init() {
    final savedTheme = CacheHelper.getData(key: _themeKey);
    if (savedTheme != null) {
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    final savedLang = CacheHelper.getData(key: _langKey);
    if (savedLang != null) {
      _locale = Locale(savedLang);
    }
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    CacheHelper.saveData(key: _themeKey, value: isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    CacheHelper.saveData(key: _langKey, value: _locale.languageCode);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    CacheHelper.saveData(
      key: _themeKey,
      value: mode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  void setLocale(Locale lo) {
    _locale = lo;
    CacheHelper.saveData(key: _langKey, value: lo.languageCode);
    notifyListeners();
  }
}

final appStateManager = AppStateManager();
