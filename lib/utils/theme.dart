import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeConfig {
  final Color appBar;
  final Color background;
  final Color mainFont;
  final Color subFont;

  ThemeConfig({
    required this.appBar,
    required this.background,
    required this.mainFont,
    required this.subFont,
  });
}

class Themes {
  static ThemeConfig lightTheme = ThemeConfig(
    appBar: Colors.deepPurple,
    background: Colors.purple[50]!,
    // background: Colors.pink,
    mainFont: Colors.deepPurple,
    subFont: Colors.black.withOpacity(0.7),
  );

  static ThemeConfig darkTheme = ThemeConfig(
    appBar: Colors.black,
    background: Colors.grey[850]!,
    mainFont: Colors.white,
    subFont: Colors.grey[400]!,
  );

  static Future<void> saveTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  static Future<bool> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false; // Default is false (light theme)
  }
}
