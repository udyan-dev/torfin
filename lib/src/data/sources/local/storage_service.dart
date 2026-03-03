import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final Map<String, dynamic> _cache = {};

  Future<T?> get<T>(String key) async {
    if (_cache.containsKey(key)) return _cache[key] as T?;

    try {
      final value = await _secureStorage.read(key: key);
      if (value == null) return null;

      final T? decoded = switch (T) {
        const (String) => value as T,
        const (int) => (int.tryParse(value) ?? 0) as T,
        const (bool) => (value == 'true') as T,
        const (double) => (double.tryParse(value) ?? 0.0) as T,
        const (List<String>) => _safeStringList(value) as T,
        _ => null,
      };

      if (decoded != null) _cache[key] = decoded;
      return decoded;
    } catch (_) {
      return null;
    }
  }

  Future<bool> set<T>(String key, T value) async {
    try {
      final stringValue = switch (T) {
        const (String) => value as String,
        const (int) => value.toString(),
        const (bool) => value.toString(),
        const (double) => value.toString(),
        const (List<String>) => jsonEncode(value),
        _ => '',
      };

      if (stringValue.isEmpty && value != '') return false;

      await _secureStorage.write(key: key, value: stringValue);
      _cache[key] = value; // Update cache
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> remove(String key) async {
    try {
      await _secureStorage.delete(key: key);
      _cache.remove(key);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      await _secureStorage.deleteAll();
      _cache.clear();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> contains(String key) async {
    if (_cache.containsKey(key)) return true;
    final value = await _secureStorage.read(key: key);
    return value != null;
  }

  List<String> _safeStringList(String value) {
    try {
      final decoded = jsonDecode(value);
      return decoded is List
          ? List<String>.from(decoded.whereType<String>())
          : [];
    } catch (_) {
      return [];
    }
  }
}
