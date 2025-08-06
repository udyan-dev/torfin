import 'package:flutter/material.dart';

import '../../../core/helpers/data_state.dart';

abstract class StorageRepository {
  Future<DataState<String>> getToken();

  Future<DataState<bool>> setToken(String token);

  Future<DataState<bool>> clearToken();

  Future<DataState<ThemeMode>> getTheme();

  Future<DataState<bool>> setTheme(ThemeMode theme);

  Future<DataState<String>> getNsfw();

  Future<DataState<bool>> setNsfw(String nsfw);

  Future<DataState<bool>> clearAll();
}
