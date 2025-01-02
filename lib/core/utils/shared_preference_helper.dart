import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _isAscendingKey = 'isAscending';
  static const _selectedPriorityKey = 'selectedPriority';

  // Save ascending state
  static Future<void> setIsAscending(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isAscendingKey, value);
  }

  // Get ascending state
  static Future<bool> getIsAscending() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAscendingKey) ?? true;  // Default is true
  }

  // Save selected priority
  static Future<void> setSelectedPriority(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_selectedPriorityKey, value);
  }

  // Get selected priority
  static Future<String> getSelectedPriority() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedPriorityKey) ?? 'all';  // Default is 'all'
  }
}
