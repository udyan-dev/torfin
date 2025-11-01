import 'package:flutter/material.dart';

import '../../../core/helpers/data_state.dart';
import '../../data/models/response/torrent/torrent_res.dart';

abstract class StorageRepository {
  Future<DataState<String>> getToken();
  Future<DataState<bool>> setToken(String token);
  Future<DataState<bool>> clearToken();

  Future<DataState<ThemeMode>> getTheme();
  Future<DataState<bool>> setTheme(ThemeMode theme);

  Future<DataState<String>> getNsfw();
  Future<DataState<bool>> setNsfw(String nsfw);

  Future<DataState<bool>> getEnableSuggestions();
  Future<DataState<bool>> setEnableSuggestions(bool enable);

  Future<DataState<bool>> clearAll();

  Future<DataState<List<TorrentRes>>> getFavorites();
  Future<DataState<bool>> setFavorites(List<TorrentRes> list);

  Future<DataState<String>> getTorrentFolder();
  Future<DataState<bool>> setTorrentFolder(String folderPath);

  Future<DataState<int>> getCoins();
  Future<DataState<bool>> setCoins(int coins);
  Future<DataState<int>> getCoinsTimestamp();

  Future<DataState<int>> getShareCount();
  Future<DataState<bool>> setShareCount(int count);
  Future<DataState<int>> getShareCountTimestamp();

  void dispose();
}
