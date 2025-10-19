import 'package:dio/dio.dart';

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
        final list = current.data ?? const <TorrentRes>[];
        final torrent = params.torrent;
        if (torrent == null) return DataSuccess(list);
        final key = torrent.identityKey;
        final found = list.any((t) => t.identityKey == key);
        final next = found
            ? list.where((t) => t.identityKey != key).toList(growable: false)
            : (List<TorrentRes>.from(list)..add(torrent));
        final setRes = await _storageRepository.setFavorites(next);
        return setRes is DataSuccess<bool>
            ? DataSuccess(next)
            : DataFailed(setRes.error!);
      case FavoriteMode.removeMultiple:
        final current = await _storageRepository.getFavorites();
        final list = current.data ?? const <TorrentRes>[];
        final torrentsToRemove = params.torrents ?? const <TorrentRes>[];
        if (torrentsToRemove.isEmpty) return DataSuccess(list);
        final keysToRemove = torrentsToRemove.map((t) => t.identityKey).toSet();
        final next = list
            .where((t) => !keysToRemove.contains(t.identityKey))
            .toList(growable: false);
        final setRes = await _storageRepository.setFavorites(next);
        return setRes is DataSuccess<bool>
            ? DataSuccess(next)
            : DataFailed(setRes.error!);
      case FavoriteMode.addMultiple:
        final current = await _storageRepository.getFavorites();
        return DataSuccess(current.data ?? const <TorrentRes>[]);
    }
  }

  Future<BatchFavoriteResult> callBatch(List<TorrentRes> torrentsToAdd) async {
    final current = await _storageRepository.getFavorites();
    final list = current.data ?? const <TorrentRes>[];

    if (torrentsToAdd.isEmpty) {
      return const BatchFavoriteResult(successCount: 0, alreadyExistsCount: 0);
    }

    final existingKeys = list.map((t) => t.identityKey).toSet();
    final newTorrents = torrentsToAdd
        .where((t) => !existingKeys.contains(t.identityKey))
        .toList();
    final alreadyExistsCount = torrentsToAdd.length - newTorrents.length;

    if (newTorrents.isEmpty) {
      return BatchFavoriteResult(
        successCount: 0,
        alreadyExistsCount: alreadyExistsCount,
      );
    }

    final next = List<TorrentRes>.from(list)..addAll(newTorrents);
    final setRes = await _storageRepository.setFavorites(next);

    if (setRes is DataSuccess<bool>) {
      return BatchFavoriteResult(
        successCount: newTorrents.length,
        alreadyExistsCount: alreadyExistsCount,
      );
    } else {
      return BatchFavoriteResult(
        successCount: 0,
        alreadyExistsCount: alreadyExistsCount,
        error: setRes.error?.message,
      );
    }
  }
}

enum FavoriteMode { getAll, toggle, removeMultiple, addMultiple }

class FavoriteParams {
  final FavoriteMode mode;
  final TorrentRes? torrent;
  final List<TorrentRes>? torrents;
  const FavoriteParams({required this.mode, this.torrent, this.torrents});
}

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
    if (error != null) {
      return failedToAddFavorites;
    }
    if (alreadyExistsCount > 0 && successCount == 0) {
      return '$alreadyExistsCount ${alreadyExistsCount == 1 ? torrentWasAlreadyInFavorites : torrentsWereAlreadyInFavorites}';
    }
    if (alreadyExistsCount > 0 && successCount > 0) {
      return '$successCount $torrentsWereAddedToFavorites';
    }
    if (successCount > 0) {
      return '$successCount $torrentsWereAddedToFavorites';
    }
    return failedToAddFavorites;
  }

  String? get message {
    if (error != null) return error;
    if (alreadyExistsCount > 0 && successCount > 0) {
      return '$alreadyExistsCount ${alreadyExistsCount == 1 ? torrentWasAlreadyInFavorites : torrentsWereAlreadyInFavorites}';
    }
    return null;
  }

  bool get isError =>
      error != null ||
      (successCount == 0 && alreadyExistsCount == 0) ||
      (successCount == 0 && alreadyExistsCount > 0);

  bool get hasPartialSuccess => alreadyExistsCount > 0 && successCount > 0;
}
