import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUsername(String username);
  Future<String?> getUsername();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  AuthLocalDataSourceImpl(this.sharedPreferences);

  static const String key = 'CACHED_USERNAME';

  @override
  Future<void> saveUsername(String username) async {
    await sharedPreferences.setString(key, username);
  }

  @override
  Future<String?> getUsername() async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> clearSession() async {
    await sharedPreferences.remove(key);
  }
}