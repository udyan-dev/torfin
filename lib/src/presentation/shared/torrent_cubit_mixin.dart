import 'package:dio/dio.dart';

import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/utils.dart';
import '../../data/engine/engine.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import '../../domain/usecases/add_torrent_use_case.dart';
import '../../domain/usecases/favorite_use_case.dart';
import '../../domain/usecases/get_magnet_use_case.dart';
import '../shared/notification_builders.dart';
import '../widgets/notification_widget.dart';

mixin TorrentCubitMixin {
  FavoriteUseCase get favoriteUseCase;
  AddTorrentUseCase get addTorrentUseCase;
  GetMagnetUseCase get getMagnetUseCase;

  Future<void> syncFavorites() async {
    final res = await favoriteUseCase(
      const FavoriteParams(mode: FavoriteMode.getAll),
      cancelToken: CancelToken(),
    );
    res.when(
      success: (data) {
        final set = toKeySet<TorrentRes>(data, (t) => t.identityKey);
        emitWithFavoriteKeys(set);
      },
    );
  }

  Future<void> toggleFavoriteImpl(TorrentRes torrent) async {
    final k = torrent.identityKey;
    final wasAdded = !isFavorite(k);
    final next = toggleKey(getFavoriteKeys(), k);
    emitWithFavoriteKeys(next);
    final res = await favoriteUseCase(
      FavoriteParams(mode: FavoriteMode.toggle, torrent: torrent),
      cancelToken: CancelToken(),
    );
    res.when(
      success: (data) {
        final set = toKeySet<TorrentRes>(data, (t) => t.identityKey);
        emitWithFavoriteKeysAndNotification(
          set,
          favoriteNotification(torrent.name, wasAdded),
        );
      },
    );
  }

  void cancelMagnetFetchImpl() {
    getMagnetCancelToken()?.cancel();
    setMagnetCancelToken(null);
    if (!isClosed && getFetchingMagnetForKey() != null) {
      emitFetchingMagnet(null);
    }
  }

  Future<void> downloadTorrentImpl(TorrentRes torrent) async {
    final key = torrent.identityKey;
    if (torrent.magnet.isEmpty) {
      emitFetchingMagnet(key);

      setMagnetCancelToken(CancelToken());
      final res = await getMagnetUseCase.call(
        torrent.url,
        cancelToken: getMagnetCancelToken()!,
      );

      if (isClosed) return;

      String? magnet;
      res.when(
        success: (links) {
          magnet = firstOrNull<String>(links);
        },
        failure: (error) {
          setMagnetCancelToken(null);
          emitFetchingMagnetWithNotification(
            null,
            errorNotification(torrent.name, error.message),
          );
        },
      );

      if (magnet == null || magnet!.isEmpty) {
        setMagnetCancelToken(null);
        emitFetchingMagnetWithNotification(
          null,
          magnetNotFoundNotification(torrent.name),
        );
        return;
      }

      final addRes = await addTorrentUseCase.call(
        AddTorrentUseCaseParams(magnetLink: magnet!),
        cancelToken: CancelToken(),
      );

      addRes.when(
        success: (response) {
          setMagnetCancelToken(null);
          final isDuplicate = response == TorrentAddedResponse.duplicated;
          emitFetchingMagnetWithNotification(
            null,
            addStartedNotification(torrent.name, isDuplicate),
          );
        },
        failure: (error) {
          setMagnetCancelToken(null);
          emitFetchingMagnetWithNotification(
            null,
            error.type == BaseExceptionType.insufficientCoins
                ? insufficientCoinsNotification()
                : addFailedNotification(torrent.name, error.message),
          );
        },
      );
      return;
    }

    final response = await addTorrentUseCase.call(
      AddTorrentUseCaseParams(magnetLink: torrent.magnet),
      cancelToken: CancelToken(),
    );

    response.when(
      success: (response) {
        final isDuplicate = response == TorrentAddedResponse.duplicated;
        emitNotification(addStartedNotification(torrent.name, isDuplicate));
      },
      failure: (error) {
        emitNotification(
          error.type == BaseExceptionType.insufficientCoins
              ? insufficientCoinsNotification()
              : addFailedNotification(torrent.name, error.message),
        );
      },
    );
  }

  bool isFavorite(String key);
  Set<String> getFavoriteKeys();
  CancelToken? getMagnetCancelToken();
  void setMagnetCancelToken(CancelToken? token);
  String? getFetchingMagnetForKey();
  bool get isClosed;

  void emitWithFavoriteKeys(Set<String> keys);
  void emitWithFavoriteKeysAndNotification(
    Set<String> keys,
    AppNotification notification,
  );
  void emitFetchingMagnet(String? key);
  void emitFetchingMagnetWithNotification(
    String? key,
    AppNotification notification,
  );
  void emitNotification(AppNotification notification);
}
