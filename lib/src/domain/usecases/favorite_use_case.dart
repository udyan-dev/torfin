import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import '../repositories/storage_repository.dart';

class FavoriteUseCase extends BaseUseCase<List<TorrentRes>, FavoriteParams> {
  FavoriteUseCase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;

  final StorageRepository _storageRepository;

  @override
  Future<DataState<List<TorrentRes>>> call(
    FavoriteParams params, {
    required CancelToken cancelToken,
  }) async {
    switch (params.mode) {
      case FavoriteMode.getAll:
        return _storageRepository.getFavorites();

      case FavoriteMode.toggle:
        final current = await _storageRepository.getFavorites();
        final list = current.data ?? const [];
        final torrent = params.torrent;
        if (torrent == null) return DataSuccess(list);

        final key = torrent.identityKey;
        final exists = list.any((t) => t.identityKey == key);
        final next = exists
            ? list.where((t) => t.identityKey != key).toList(growable: false)
            : [...list, torrent];

        final setRes = await _storageRepository.setFavorites(next);
        return setRes is DataSuccess
            ? DataSuccess(next)
            : DataFailed(setRes.error!);

      case FavoriteMode.removeMultiple:
        final current = await _storageRepository.getFavorites();
        final list = current.data ?? const [];
        final toRemove = params.torrents ?? const [];
        if (toRemove.isEmpty) return DataSuccess(list);

        final removeKeys = toRemove.map((t) => t.identityKey).toSet();
        final next = list
            .where((t) => !removeKeys.contains(t.identityKey))
            .toList(growable: false);

        final setRes = await _storageRepository.setFavorites(next);
        return setRes is DataSuccess
            ? DataSuccess(next)
            : DataFailed(setRes.error!);

      case FavoriteMode.addMultiple:
        return _storageRepository.getFavorites();
    }
  }

  Future<BatchFavoriteResult> callBatch(List<TorrentRes> torrentsToAdd) async {
    if (torrentsToAdd.isEmpty) {
      return const BatchFavoriteResult(successCount: 0, alreadyExistsCount: 0);
    }

    final current = await _storageRepository.getFavorites();
    final list = current.data ?? const [];

    final existingKeys = list.map((t) => t.identityKey).toSet();
    final newTorrents = torrentsToAdd
        .where((t) => !existingKeys.contains(t.identityKey))
        .toList();
    final existsCount = torrentsToAdd.length - newTorrents.length;

    if (newTorrents.isEmpty) {
      return BatchFavoriteResult(
        successCount: 0,
        alreadyExistsCount: existsCount,
      );
    }

    final next = [...list, ...newTorrents];
    final setRes = await _storageRepository.setFavorites(next);

    return setRes is DataSuccess
        ? BatchFavoriteResult(
            successCount: newTorrents.length,
            alreadyExistsCount: existsCount,
          )
        : BatchFavoriteResult(
            successCount: 0,
            alreadyExistsCount: existsCount,
            error: setRes.error?.message,
          );
  }
}

enum FavoriteMode { getAll, toggle, removeMultiple, addMultiple }

class FavoriteParams {
  final FavoriteMode mode;
  final TorrentRes? torrent;
  final List<TorrentRes>? torrents;
  const FavoriteParams({required this.mode, this.torrent, this.torrents});
}

@immutable
class BatchFavoriteResult {
  final int successCount;
  final int alreadyExistsCount;
  final String? error;

  const BatchFavoriteResult({
    required this.successCount,
    required this.alreadyExistsCount,
    this.error,
  });

  String get title {
    if (error != null) return failedToAddFavorites;
    if (alreadyExistsCount > 0 && successCount == 0) {
      return '$alreadyExistsCount $torrentsWereAlreadyInFavorites';
    }
    return successCount > 0
        ? '$successCount $torrentsWereAddedToFavorites'
        : failedToAddFavorites;
  }

  String? get message =>
      error ??
      (hasPartialSuccess
          ? '$alreadyExistsCount $torrentsWereAlreadyInFavorites'
          : null);

  bool get isError => error != null || (successCount == 0);

  bool get hasPartialSuccess => alreadyExistsCount > 0 && successCount > 0;
}
