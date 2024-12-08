import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torfin/core/utils/app_constants.dart';

/// Base class containing a unified API for key-value pairs' storage.
/// This class provides low level methods for storing:
/// - Insensitive keys using [SharedPreferences]
class StorageService {
  /// Instance of shared preferences
  static SharedPreferences? _sharedPrefs;

  /// Singleton instance of KeyValueStorage Helper
  static StorageService? _instance;

  /// Get instance of this class
  factory StorageService() => _instance ??= const StorageService._();

  /// Private constructor
  const StorageService._();

  /// Erases common preferences keys
  Future<bool> clearCommon() => _sharedPrefs!.clear();

  // List<TorFinEntity> getAllModels() {
  //   List<TorFinEntity> torrents = [];
  //   String? keysString = getCommon<String>(Constants.saved);
  //
  //   if (keysString != null) {
  //     List<String> keys = List<String>.from(jsonDecode(keysString));
  //     for (var key in keys) {
  //       final model = getModel(key);
  //       if (model != null) {
  //         torrents.add(model);
  //       }
  //     }
  //   }
  //   return torrents;
  // }

  T? getCommon<T>(String key) {
    try {
      final value = _sharedPrefs!.get(key);
      if (value is T) return value;
    } catch (ex) {
      debugPrint('$ex');
    }
    return null;
  }

  // TorFinEntity? getModel(String key) {
  //   final modelJson = getCommon<String>(key);
  //   if (modelJson != null) {
  //     final modelMap = jsonDecode(modelJson);
  //     return TorFinEntity.fromJson(modelMap);
  //   }
  //   return null;
  // }

  // Future<bool?> getTheme() async {
  //   return getCommon<bool>(Constants.themeMode);
  // }
  //
  // Future<bool?> getNSFW() async {
  //   return getCommon<bool>(Constants.nsfw);
  // }
  //
  String? getToken() {
    return getCommon<String>(AppConstants.keyToken);
  }

  //
  // Future<void> removeAllModels() async {
  //   String? keysString = getCommon<String>(Constants.saved);
  //   if (keysString != null) {
  //     List<String> keys = List<String>.from(jsonDecode(keysString));
  //     await Future.forEach(keys, (String key) async {
  //       await _sharedPrefs!.remove(key);
  //     });
  //     await setCommon(Constants.saved, jsonEncode([]));
  //   }
  // }
  //
  // Future<void> removeModel(TorFinEntity torrent) async {
  //   final key = torrent.magnet;
  //   await _sharedPrefs!.remove(key);
  //
  //   String? keysString = getCommon<String>(Constants.saved);
  //   if (keysString != null) {
  //     List<String> keys = List<String>.from(jsonDecode(keysString));
  //     if (keys.remove(key)) {
  //       await setCommon(Constants.saved, jsonEncode(keys));
  //     }
  //   }
  // }
  //
  // Future<void> saveBlackList(List<String> blackList) async {
  //   await setCommon(Constants.blackList, blackList);
  // }
  //
  // Future<void> saveModel(TorFinEntity torrent) async {
  //   final key = torrent.magnet;
  //   final modelJson = jsonEncode(torrent.toJson());
  //   await setCommon(key, modelJson);
  //
  //   String? keysString = getCommon<String>(Constants.saved);
  //   if (keysString != null) {
  //     List<String> keys = List<String>.from(jsonDecode(keysString));
  //     if (!keys.contains(key)) {
  //       keys.add(key);
  //       await setCommon(Constants.saved, jsonEncode(keys));
  //     }
  //   } else {
  //     await setCommon(Constants.saved, jsonEncode([key]));
  //   }
  // }
  //
  Future<void> saveToken(String token) async {
    await setCommon(AppConstants.keyToken, token);
  }

  Future<bool> setCommon<T>(String key, T value) async {
    if (value is String) return await _sharedPrefs!.setString(key, value);
    if (value is int) return await _sharedPrefs!.setInt(key, value);
    if (value is bool) return await _sharedPrefs!.setBool(key, value);
    if (value is double) return await _sharedPrefs!.setDouble(key, value);
    if (value is List<String>) {
      return await _sharedPrefs!.setStringList(key, value);
    }
    return await _sharedPrefs!.setString(key, value.toString());
  }

  //
  // Future<void> setTheme(bool theme) async {
  //   await setCommon(Constants.themeMode, theme);
  // }
  //
  // Future<void> setNSFW(bool nsfw) async {
  //   await setCommon(Constants.nsfw, nsfw);
  // }

  static Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }
}
