import 'package:dio/dio.dart';

import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
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
    }
  }
}

enum FavoriteMode { getAll, toggle, removeMultiple }

class FavoriteParams {
  final FavoriteMode mode;
  final TorrentRes? torrent;
  final List<TorrentRes>? torrents;
  const FavoriteParams({required this.mode, this.torrent, this.torrents});
}
