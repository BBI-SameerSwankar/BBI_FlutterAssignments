import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeConfig {
  final Color appBar;
  final Color background;
  final Color card;
  final Color mainFont;
  final Color subFont;

  ThemeConfig({
    required this.appBar,
    required this.background,
    required this.card,
    required this.mainFont,
    required this.subFont,
  });
}

class Themes {
  static ThemeConfig lightTheme = ThemeConfig(
    appBar: Colors.deepPurple,
    background: Colors.purple[50]!,
    card: Colors.white,
    mainFont: Colors.black87,
    subFont: Colors.black54,
  );

  static ThemeConfig darkTheme = ThemeConfig(
    appBar: Colors.black,
    card: Colors.grey[850]!,
    background: Colors.black,
    mainFont: Colors.white,
    subFont: Colors.grey, 
  );

  static Future<void> saveTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  static Future<bool> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false; 
  }
}