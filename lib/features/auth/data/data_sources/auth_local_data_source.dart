import 'package:shared_preferences/shared_preferences.dart';

// Abstract class
abstract class AuthLocalDataSource {
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> clearUserId();
}

// Implementation of the abstract class
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUserId(String userId) async {
    await sharedPreferences.setString('user_id', userId);
  } 

  @override
  Future<String?> getUserId() async {
    return sharedPreferences.getString('user_id');
  }

  @override
  Future<void> clearUserId() async {
    await sharedPreferences.remove('user_id');
  }
}
