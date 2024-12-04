import 'package:flutter/material.dart';
import 'package:search_app/homepage.dart'; // Adjust the path if necessary
import 'package:search_app/utils/theme.dart'; // Adjust the path if necessary
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  // Themes.saveTheme(true);
  // bool isDarkMode = await Themes.loadTheme(); // Load saved theme preference
  bool isDarkMode = false; // Load saved theme preference
  
  print(isDarkMode);
  runApp(MainApp(isDarkMode: isDarkMode));
}

class MainApp extends StatelessWidget {
  final bool isDarkMode;

  const MainApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App with Theme Persistence',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePage( ),
    );
  }
}
