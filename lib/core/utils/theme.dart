import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Colors.blueAccent;
  static const Color secondaryColor = Colors.white;
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light gray background

  // Text Styles
  static const TextStyle appBarTextStyle = TextStyle(
    color: secondaryColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 16,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: secondaryColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // Icon Themes
  static const IconThemeData iconTheme = IconThemeData(
    color: secondaryColor,
  );

  // Button Styles
  static ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor, // Use backgroundColor instead of primary
    foregroundColor: secondaryColor, // Use foregroundColor instead of onPrimary
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: primaryColor, // Keep this as is for the outlined button
    side: BorderSide(color: primaryColor),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        iconTheme: iconTheme,
        titleTextStyle: appBarTextStyle,
      ),
      textTheme: TextTheme(
        bodyLarge: bodyTextStyle, // Updated to bodyLarge
        bodyMedium: bodyTextStyle, // Updated to bodyMedium
        bodySmall: bodyTextStyle, // Updated to bodySmall
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: raisedButtonStyle,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: outlinedButtonStyle,
      ),
      iconTheme: iconTheme,
      brightness: Brightness.light,
    );
  }
}
