import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  factory StorageManager() {
    return _instance;
  }

  StorageManager._internal();
  static final StorageManager _instance = StorageManager._internal();
  static late SharedPreferences _sharedPref;

  static Future<void> initializeSharedPreferences() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  static Future<void> clearSharedPreferences() async {
    await _sharedPref.clear();
  }

  static Future<void> removeValue(key) async {
    await _sharedPref.remove(key);
  }

  static void setIntValue({required String key, required int value}) {
    _sharedPref.setInt(key, value);
  }

  static int? getIntValue(String key) {
    return _sharedPref.getInt(key);
  }

  static void setBoolValue({required String key, required bool value}) async {
    _sharedPref.setBool(key, value);
  }

  static bool? getBoolValue(String key) {
    return _sharedPref.getBool(key);
  }

  static void setStringValue({required String key, required String value}) {
    _sharedPref.setString(key, value);
  }

  static String? getStringValue(String key) {
    return _sharedPref.getString(key);
  }

  static Future<void> setHeight({
    required String key,
    required Map<String, dynamic> height,
  }) async {
    var heightJson = jsonEncode(height);
    await _sharedPref.setString(key, heightJson);
  }

  static Map<String, int>? getHeight(String key) {
    var heightJson = _sharedPref.getString(key);
    Map<String, dynamic> heightMap = jsonDecode(heightJson!);
    return heightMap.map((k, v) => MapEntry(k, v as int));
  }
}
