import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:torfin/core/utils/app_constant.dart';
import 'package:torfin/src/data/model/response/torrent/torrent_res.dart';
import 'package:torfin/src/data/source/local/app_storage.dart';

import '../../../core/helper/app_exception.dart';
import '../../domain/repository/storage_repository.dart';

class StorageRepositoryImp implements StorageRepository {
  final AppStorage appStorage;

  StorageRepositoryImp({required this.appStorage});

  @override
  Future<String> getToken() async {
    try {
      return await appStorage.getCommon<String>(AppConstant.token) ?? "";
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: 'Failed to get token: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> setToken({required String token}) async {
    try {
      return await appStorage.setCommon<String>(AppConstant.token, token);
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: 'Failed to set token: ${e.toString()}',
      );
    }
  }

  @override
  Future<ThemeMode> getTheme() async {
    try {
      final themeIndex =
          (await appStorage.getCommon<int>(AppConstant.theme)) as int;
      return themeIndex >= 0 && themeIndex < ThemeMode.values.length
          ? ThemeMode.values[themeIndex]
          : ThemeMode.system;
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: 'Failed to get theme: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> setTheme({required ThemeMode themeMode}) async {
    try {
      return await appStorage.setCommon<int>(
        AppConstant.theme,
        themeMode.index,
      );
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: 'Failed to set theme: ${e.toString()}',
      );
    }
  }

  @override
  Future<String> getNsfw() async {
    try {
      return await appStorage.getCommon<String>(AppConstant.nsfw) ?? "0";
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: 'Failed to get nsfw: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> setNsfw({required String nsfw}) async {
    try {
      return await appStorage.setCommon<String>(AppConstant.nsfw, nsfw);
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: 'Failed to set token: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<TorrentRes>> getSavedTorrents() async {
    try {
      final result = await appStorage.getCommon<List<String>>(
        AppConstant.saveTorrent,
      );
      if (result == null || result.isEmpty) return [];

      return result.map((e) => TorrentRes.fromJson(jsonDecode(e))).toList();
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: 'Failed to retrieve saved torrents: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> removeTorrent({required String torrentId}) async {
    try {
      final savedTorrents = await getSavedTorrents();
      savedTorrents.removeWhere((torrent) => torrent.magnet == torrentId);

      final jsonString =
          savedTorrents.map((torrent) => jsonEncode(torrent)).toList();

      return await appStorage.setCommon<List<String>>(
        AppConstant.saveTorrent,
        jsonString,
      );
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: 'Failed to remove torrent: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> saveTorrent({required TorrentRes torrent}) async {
    try {
      final savedTorrents = await getSavedTorrents();
      if (!savedTorrents.any((e) => e.magnet == torrent.magnet)) {
        savedTorrents.add(torrent);
      }

      final jsonString =
          savedTorrents.map((torrent) => jsonEncode(torrent)).toList();

      return await appStorage.setCommon<List<String>>(
        AppConstant.saveTorrent,
        jsonString,
      );
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: 'Failed to save torrent: ${e.toString()}',
      );
    }
  }
}
