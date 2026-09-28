import 'package:evently_app_abbas/core/prefs_manager/prefs_manager.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode currentTheme = PrefsManager.getSavedTheme() ?? ThemeMode.light;


  bool get isDark => currentTheme == ThemeMode.dark;

  void changeAppTheme(ThemeMode newTheme) {
    currentTheme = newTheme;
    PrefsManager.saveCurrentTheme(currentTheme);

    notifyListeners();
  }



}
