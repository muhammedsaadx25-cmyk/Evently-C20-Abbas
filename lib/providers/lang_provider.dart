import 'package:evently_app_abbas/core/prefs_manager/prefs_manager.dart';
import 'package:flutter/material.dart';

class LangProvider extends ChangeNotifier {
  String currentLanguage = PrefsManager.getSavedLang() ?? 'en';
  bool get isEnglish  => currentLanguage == 'en';

  void changeAppLang(String newLang){
    if(currentLanguage == newLang)return;
    currentLanguage = newLang;
    PrefsManager.saveCurrentLang(currentLanguage);
    notifyListeners();
  }
}