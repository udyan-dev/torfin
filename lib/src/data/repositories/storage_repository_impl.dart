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
    request: () => _storageService
        .get<String>(tokenKey)
        .then((value) => value ?? emptyString),
  );

  @override
  Future<DataState<bool>> setToken(String token) =>
      getStateOf(request: () => _storageService.set(tokenKey, token));

  @override
  Future<DataState<bool>> clearToken() =>
      getStateOf(request: () => _storageService.set(tokenKey, emptyString));

  @override
  Future<DataState<ThemeMode>> getTheme() => getStateOf(
    request: () => _storageService
        .get<int>(themeKey)
        .then(
          (index) => index == null
              ? ThemeMode.system
              : ThemeMode.values[index.clamp(0, ThemeMode.values.length - 1)],
        ),
  );

  @override
  Future<DataState<bool>> setTheme(ThemeMode theme) =>
      getStateOf(request: () => _storageService.set(themeKey, theme.index));

  @override
  Future<DataState<String>> getNsfw() => getStateOf(
    request: () =>
        _storageService.get<String>(nsfwKey).then((value) => value ?? "0"),
  );

  @override
  Future<DataState<bool>> setNsfw(String nsfw) =>
      getStateOf(request: () => _storageService.set(nsfwKey, nsfw));

  @override
  Future<DataState<bool>> getEnableSuggestions() => getStateOf(
    request: () => _storageService
        .get<bool>(enableSuggestionsKey)
        .then((value) => value ?? true),
  );

  @override
  Future<DataState<bool>> setEnableSuggestions(bool enable) =>
      getStateOf(request: () => _storageService.set(enableSuggestionsKey, enable));

  @override
  Future<DataState<bool>> clearAll() =>
      getStateOf(request: () => _storageService.clear());

  @override
  Future<DataState<List<TorrentRes>>> getFavorites() => getStateOf(
    request: () => _storageService.get<List<String>>(favoritesKey).then((list) {
      final items = list ?? [];
      if (items.isEmpty) return <TorrentRes>[];
      final out = <TorrentRes>[];
      for (int i = 0; i < items.length; i++) {
        try {
          out.add(
            TorrentRes.fromJson(jsonDecode(items[i]) as Map<String, dynamic>),
          );
        } catch (_) {}
      }
      return out;
    }),
  );

  @override
  Future<DataState<bool>> setFavorites(List<TorrentRes> list) => getStateOf(
    request: () {
      final serialized = <String>[];
      for (int i = 0; i < list.length; i++) {
        serialized.add(jsonEncode(list[i].toJson()));
      }
      return _storageService.set<List<String>>(favoritesKey, serialized);
    },
  );

  @override
  Future<DataState<String>> getTorrentFolder() => getStateOf(
    request: () => _storageService
        .get<String>(downloadLocationKey)
        .then((value) => value ?? emptyString),
  );

  @override
  Future<DataState<bool>> setTorrentFolder(String folderPath) => getStateOf(
    request: () => _storageService.set(downloadLocationKey, folderPath),
  );
}
