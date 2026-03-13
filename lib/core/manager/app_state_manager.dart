import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  // Singleton pattern for easy access if needed,
  // though using it via Provider/ListenableBuilder is better.
  static final AppStateManager _instance = AppStateManager._internal();
  factory AppStateManager() => _instance;
  AppStateManager._internal();

  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale(
    'ar',
  ); // Default to Arabic as per project context

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isArabic => _locale.languageCode == 'ar';

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLocale(Locale lo) {
    _locale = lo;
    notifyListeners();
  }
}

final appStateManager = AppStateManager();
