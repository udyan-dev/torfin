import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/string_constants.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<T?> get<T>(String key) async => (await _preferences).get(key) as T?;

  Future<bool> set<T>(String key, T value) async {
    final prefs = await _preferences;
    return switch (T) {
      const (String) => prefs.setString(key, value as String),
      const (int) => prefs.setInt(key, value as int),
      const (bool) => prefs.setBool(key, value as bool),
      const (double) => prefs.setDouble(key, value as double),
      const (List<String>) => prefs.setStringList(key, value as List<String>),
      _ => throw StorageException('$unsupportedTypeError: ${T.runtimeType}'),
    };
  }

  Future<bool> remove(String key) async => (await _preferences).remove(key);

  Future<bool> clear() async => (await _preferences).clear();

  Future<bool> contains(String key) async =>
      (await _preferences).containsKey(key);

  Future<Set<String>> getKeys() async => (await _preferences).getKeys();
}

class StorageException implements Exception {
  const StorageException(this.message);

  final String message;

  @override
  String toString() => '$storageExceptionPrefix$message';
}
