import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {

  static late SharedPreferences prefs;
 static Future<void> init()async{
    prefs = await SharedPreferences.getInstance();
  }

  static void saveCurrentTheme(ThemeMode currentTheme) async {
    String theme = currentTheme == ThemeMode.light ? "Light" : "Dark";

    prefs.setString("current_theme", theme);
  }


static ThemeMode? getSavedTheme(){

    String? savedTheme = prefs.getString("current_theme");
    if(savedTheme == null) return null;
    return savedTheme == "Light" ? ThemeMode.light : ThemeMode.dark;

  }

  static void saveCurrentLang(String currentLang){
   prefs.setString("currentLang", currentLang);
  }

  static String? getSavedLang(){
   return prefs.getString("currentLang");
  }
}
