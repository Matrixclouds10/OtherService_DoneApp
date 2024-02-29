import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  const AppPrefs({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  })  : _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences;

  /// shared prefs

  dynamic get(String key, {dynamic defaultValue}) => _sharedPreferences.get(key) ?? defaultValue;

  Future<bool> save(String key, var value) async {
    if (value is String) {
      return await _sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await _sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      return await _sharedPreferences.setBool(key, value);
    } else if (value is double) {
      return await _sharedPreferences.setDouble(key, value);
    } else {
      return await _sharedPreferences.setStringList(key, value);
    }
  }

  void clear() => _sharedPreferences.clear();

  /// Secure storage

  Future<bool> delete(String key) async => await _sharedPreferences.remove(key);

  Future<String?> getSecuredData(String key) async => await _secureStorage.read(key: key);

  Future<void> saveSecuredData(String key, String value) async => await _secureStorage.write(key: key, value: value);

  Future<void> deleteSecuredData() async {
    await _secureStorage.deleteAll();
    await FirebaseMessaging.instance.deleteToken();
  }
}
