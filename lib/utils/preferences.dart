import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._internal();

  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  late SharedPreferences _prefs;

  Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> clearPrefs() => _prefs.clear();
  Future<bool> removePrefs(String key)async => _prefs.remove(key);



}