import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/utils/string_constants.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<T?> get<T>(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      if (value == null) return null;

      return switch (T) {
        const (String) => value as T,
        const (int) => (int.tryParse(value) ?? 0) as T,
        const (bool) => (value == 'true') as T,
        const (double) => (double.tryParse(value) ?? 0.0) as T,
        const (List<String>) => _safeStringList(value) as T,
        _ => null as T?,
      };
    } catch (e) {
      return null;
    }
  }

  Future<bool> set<T>(String key, T value) async {
    try {
      final stringValue = switch (T) {
        const (String) => value as String,
        const (int) => (value as int).toString(),
        const (bool) => (value as bool).toString(),
        const (double) => (value as double).toString(),
        const (List<String>) => jsonEncode(value as List<String>),
        _ => '',
      };

      if (stringValue.isEmpty) return false;
      await _secureStorage.write(key: key, value: stringValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> remove(String key) async {
    try {
      await _secureStorage.delete(key: key);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      await _secureStorage.deleteAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> contains(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  Future<Set<String>> getKeys() async {
    try {
      final allEntries = await _secureStorage.readAll();
      return allEntries.keys.toSet();
    } catch (e) {
      return <String>{};
    }
  }

  List<String> _safeStringList(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! List) return <String>[];
      final result = <String>[];
      for (final item in decoded) {
        if (item is String) {
          result.add(item);
        }
      }
      return result;
    } catch (_) {
      return <String>[];
    }
  }
}

class StorageException implements Exception {
  const StorageException(this.message);

  final String message;

  @override
  String toString() => '$storageExceptionPrefix$message';
}
