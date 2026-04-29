import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/base_repository.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/string_constants.dart';
import '../../domain/repositories/storage_repository.dart';
import '../models/response/torrent/torrent_res.dart';
import '../services/coins_sync_service.dart';
import '../sources/local/storage_service.dart';

const String _coinsTimestampKey = 'coinsTimestamp';
const String _shareCountTimestampKey = 'shareCountTimestamp';

class StorageRepositoryImpl extends BaseRepository
    implements StorageRepository {
  StorageRepositoryImpl({
    required StorageService storageService,
    CoinsSyncService? coinsSyncService,
  }) : _storageService = storageService,
       _coinsSyncService = coinsSyncService,
       _coinsController = StreamController<int>.broadcast();

  final StorageService _storageService;
  CoinsSyncService? _coinsSyncService;
  final StreamController<int> _coinsController;
  int? _cachedCoins;

  @override
  void setCoinsSyncService(CoinsSyncService coinsSyncService) {
    _coinsSyncService = coinsSyncService;
  }

  @override
  Stream<int> get coinsStream => _coinsController.stream;

  void _emitCoins(int coins) {
    if (_cachedCoins == coins) return;
    _cachedCoins = coins;
    if (!_coinsController.isClosed) {
      _coinsController.add(coins);
    }
  }

  @override
  void dispose() {
    if (!_coinsController.isClosed) {
      _coinsController.close();
    }
  }

  @override
  Future<DataState<String>> getToken() => getStateOf(
    request: () =>
        _storageService.get<String>(tokenKey).then((v) => v ?? emptyString),
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
    request: () => _storageService.get<String>(nsfwKey).then((v) => v ?? "0"),
  );

  @override
  Future<DataState<bool>> setNsfw(String nsfw) =>
      getStateOf(request: () => _storageService.set(nsfwKey, nsfw));

  @override
  Future<DataState<bool>> getEnableSuggestions() => getStateOf(
    request: () =>
        _storageService.get<bool>(enableSuggestionsKey).then((v) => v ?? true),
  );

  @override
  Future<DataState<bool>> setEnableSuggestions(bool enable) => getStateOf(
    request: () => _storageService.set(enableSuggestionsKey, enable),
  );

  @override
  Future<DataState<bool>> clearAll() =>
      getStateOf(request: () => _storageService.clear());

  @override
  Future<DataState<List<TorrentRes>>> getFavorites() => getStateOf(
    request: () async {
      final list = await _storageService.get<List<String>>(favoritesKey);
      if (list == null || list.isEmpty) return <TorrentRes>[];
      return await compute(_decodeFavorites, list);
    },
  );

  @override
  Future<DataState<bool>> setFavorites(List<TorrentRes> list) => getStateOf(
    request: () async {
      final serialized = await compute(_encodeFavorites, list);
      return _storageService.set<List<String>>(favoritesKey, serialized);
    },
  );

  @override
  Future<DataState<String>> getTorrentFolder() => getStateOf(
    request: () => _storageService
        .get<String>(downloadLocationKey)
        .then((v) => v ?? emptyString),
  );

  @override
  Future<DataState<bool>> setTorrentFolder(String folderPath) => getStateOf(
    request: () => _storageService.set(downloadLocationKey, folderPath),
  );

  @override
  Future<DataState<int>> getCoins() => getStateOf(
    request: () =>
        _storageService.get<int>(coinsKey).then((v) => v ?? initialCoins),
  );

  @override
  Future<DataState<bool>> setCoins(int coins) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final result = await getStateOf(
      request: () async {
        final success = await _storageService.set(coinsKey, coins);
        if (success) await _storageService.set(_coinsTimestampKey, timestamp);
        return success;
      },
    );
    if (result is DataSuccess<bool> && result.data == true) {
      _emitCoins(coins);
      unawaited(_coinsSyncService?.syncCoinsAfterChange(coins, timestamp));
    }
    return result;
  }

  @override
  Future<DataState<int>> getCoinsTimestamp() => getStateOf(
    request: () =>
        _storageService.get<int>(_coinsTimestampKey).then((v) => v ?? 0),
  );

  @override
  Future<DataState<int>> getShareCount() => getStateOf(
    request: () => _storageService.get<int>(shareCountKey).then((v) => v ?? 0),
  );

  @override
  Future<DataState<bool>> setShareCount(int count) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final result = await getStateOf(
      request: () async {
        final success = await _storageService.set(shareCountKey, count);
        if (success) {
          await _storageService.set(_shareCountTimestampKey, timestamp);
        }
        return success;
      },
    );
    if (result is DataSuccess<bool> && result.data == true) {
      unawaited(_coinsSyncService?.syncShareCountAfterChange(count, timestamp));
    }
    return result;
  }

  @override
  Future<DataState<int>> getShareCountTimestamp() => getStateOf(
    request: () =>
        _storageService.get<int>(_shareCountTimestampKey).then((v) => v ?? 0),
  );
}

List<TorrentRes> _decodeFavorites(List<String> items) {
  return items.map((e) => TorrentRes.fromJson(jsonDecode(e))).toList();
}

List<String> _encodeFavorites(List<TorrentRes> list) {
  return list.map((e) => jsonEncode(e.toJson())).toList();
}
