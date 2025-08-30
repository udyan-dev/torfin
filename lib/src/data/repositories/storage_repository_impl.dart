import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/helpers/base_repository.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/string_constants.dart';
import '../../domain/repositories/storage_repository.dart';
import '../sources/local/storage_service.dart';
import '../models/response/torrent/torrent_res.dart';

class StorageRepositoryImpl extends BaseRepository
    implements StorageRepository {
  StorageRepositoryImpl({required StorageService storageService})
    : _storageService = storageService;

  final StorageService _storageService;

  @override
  Future<DataState<String>> getToken() => getStateOf(
    request: () async =>
        await _storageService.get<String>(tokenKey) ?? emptyString,
  );

  @override
  Future<DataState<bool>> setToken(String token) =>
      getStateOf(request: () => _storageService.set(tokenKey, token));

  @override
  Future<DataState<bool>> clearToken() =>
      getStateOf(request: () => _storageService.set(tokenKey, emptyString));

  @override
  Future<DataState<ThemeMode>> getTheme() => getStateOf(
    request: () async {
      final index = await _storageService.get<int>(themeKey);
      return index == null
          ? ThemeMode.system
          : ThemeMode.values[index.clamp(0, ThemeMode.values.length - 1)];
    },
  );

  @override
  Future<DataState<bool>> setTheme(ThemeMode theme) =>
      getStateOf(request: () => _storageService.set(themeKey, theme.index));

  @override
  Future<DataState<String>> getNsfw() => getStateOf(
    request: () async => await _storageService.get<String>(nsfwKey) ?? "0",
  );

  @override
  Future<DataState<bool>> setNsfw(String nsfw) =>
      getStateOf(request: () => _storageService.set(nsfwKey, nsfw));

  @override
  Future<DataState<bool>> clearAll() =>
      getStateOf(request: () => _storageService.clear());

  @override
  Future<DataState<List<TorrentRes>>> getFavorites() => getStateOf(
    request: () async {
      final list = await _storageService.get<List<String>>(favoritesKey) ?? [];
      if (list.isEmpty) return <TorrentRes>[];
      final out = <TorrentRes>[];
      for (int i = 0; i < list.length; i++) {
        try {
          out.add(TorrentRes.fromJson(jsonDecode(list[i]) as Map<String, dynamic>));
        } catch (_) {}
      }
      return out;
    },
  );

  @override
  Future<DataState<bool>> setFavorites(List<TorrentRes> list) => getStateOf(
    request: () async {
      final serialized = <String>[];
      for (int i = 0; i < list.length; i++) {
        serialized.add(jsonEncode(list[i].toJson()));
      }
      return _storageService.set<List<String>>(favoritesKey, serialized);
    },
  );
}
