import 'package:flutter/material.dart';

import '../../data/model/response/torrent/torrent_res.dart';

abstract class StorageRepository {
  Future<String> getToken();

  Future<bool> setToken({required String token});

  Future<String> getNsfw();

  Future<bool> setNsfw({required String nsfw});

  Future<ThemeMode> getTheme();

  Future<bool> setTheme({required ThemeMode themeMode});

  Future<bool> saveTorrent({required TorrentRes torrent});

  Future<bool> removeTorrent({required String torrentId});

  Future<List<TorrentRes>> getSavedTorrents();
}
