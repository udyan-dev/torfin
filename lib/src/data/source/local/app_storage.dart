import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static AppStorage? _instance;
  static SharedPreferences? _sharedPreferences;

  AppStorage._();

  static Future<AppStorage> getInstance() async {
    _instance ??= AppStorage._();
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> clearCommon() async {
    try {
      return await _sharedPreferences?.clear() ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<T?> getCommon<T>(String key) async {
    try {
      final prefs = _sharedPreferences;
      if (prefs == null) return null;

      return switch (T) {
        const (String) => prefs.getString(key) as T?,
        const (int) => prefs.getInt(key) as T?,
        const (bool) => prefs.getBool(key) as T?,
        const (double) => prefs.getDouble(key) as T?,
        const (List<String>) => prefs.getStringList(key) as T?,
        _ => null,
      };
    } catch (e) {
      return null;
    }
  }

  Future<bool> setCommon<T>(String key, T value) async {
    try {
      final prefs = _sharedPreferences;
      if (prefs == null) return false;

      return switch (T) {
        const (String) => await prefs.setString(key, value as String),
        const (int) => await prefs.setInt(key, value as int),
        const (bool) => await prefs.setBool(key, value as bool),
        const (double) => await prefs.setDouble(key, value as double),
        const (List<String>) => await prefs.setStringList(
          key,
          value as List<String>,
        ),
        _ => false,
      };
    } catch (e) {
      return false;
    }
  }
}
