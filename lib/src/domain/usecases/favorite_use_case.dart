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
        final next = <TorrentRes>[];
        bool found = false;
        for (int i = 0; i < list.length; i++) {
          if (list[i].identityKey == key) {
            found = true;
          } else {
            next.add(list[i]);
          }
        }
        if (!found) next.add(torrent);
        final setRes = await _storageRepository.setFavorites(next);
        return setRes is DataSuccess<bool>
            ? DataSuccess(next)
            : DataFailed(setRes.error!);
    }
  }
}

enum FavoriteMode { getAll, toggle }

class FavoriteParams {
  final FavoriteMode mode;
  final TorrentRes? torrent;
  const FavoriteParams({required this.mode, this.torrent});
}
