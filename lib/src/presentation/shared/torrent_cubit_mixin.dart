import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/utils.dart';
import '../../data/engine/engine.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import '../../domain/usecases/add_torrent_use_case.dart';
import '../../domain/usecases/favorite_use_case.dart';
import '../../domain/usecases/get_magnet_use_case.dart';
import '../../domain/usecases/share_torrent_use_case.dart';
import '../shared/notification_builders.dart';
import '../widgets/notification_widget.dart';

mixin TorrentCubitMixin {
  FavoriteUseCase get favoriteUseCase;
  AddTorrentUseCase get addTorrentUseCase;
  GetMagnetUseCase get getMagnetUseCase;
  ShareTorrentUseCase get shareTorrentUseCase;

  Future<void> syncFavorites() async {
    final res = await favoriteUseCase(
      const FavoriteParams(mode: FavoriteMode.getAll),
      cancelToken: CancelToken(),
    );
    if (isClosed) return;
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
    if (isClosed) return;
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

  Future<void> downloadTorrentImpl(
    TorrentRes torrent,
    BuildContext context,
  ) async {
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
      if (isClosed) return;
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
          if (error.type == BaseExceptionType.insufficientCoins) {
            emitFetchingMagnet(null);
            if (context.mounted) {
              NotificationWidget.notify(
                context,
                insufficientCoinsNotification(),
              );
            }
          } else {
            emitFetchingMagnetWithNotification(
              null,
              addFailedNotification(torrent.name, error.message),
            );
          }
        },
      );
      return;
    }
    final response = await addTorrentUseCase.call(
      AddTorrentUseCaseParams(magnetLink: torrent.magnet),
      cancelToken: CancelToken(),
    );
    if (isClosed) return;
    response.when(
      success: (response) {
        final isDuplicate = response == TorrentAddedResponse.duplicated;
        emitNotification(addStartedNotification(torrent.name, isDuplicate));
      },
      failure: (error) {
        if (error.type == BaseExceptionType.insufficientCoins) {
          if (context.mounted) {
            NotificationWidget.notify(context, insufficientCoinsNotification());
          }
        } else {
          emitNotification(addFailedNotification(torrent.name, error.message));
        }
      },
    );
  }

  Future<void> shareTorrentImpl(
    TorrentRes torrent,
    BuildContext dialogContext,
  ) async {
    final result = await shareTorrentUseCase.call(
      ShareTorrentUseCaseParams(
        magnetLink: torrent.magnet,
        torrentName: torrent.name,
      ),
      cancelToken: CancelToken(),
    );
    if (isClosed) return;
    result.when(
      success: (_) {
        if (dialogContext.mounted) {
          Navigator.of(dialogContext).maybePop();
        }
      },
      failure: (error) {
        if (dialogContext.mounted) {
          Navigator.of(dialogContext).maybePop();
        }
        if (error.type == BaseExceptionType.insufficientCoins) {
          if (dialogContext.mounted) {
            NotificationWidget.notify(
              dialogContext,
              insufficientCoinsNotification(),
            );
          }
        } else {
          emitNotification(
            AppNotification(
              type: NotificationType.error,
              message: error.message,
            ),
          );
        }
      },
    );
  }

  bool isFavorite(String key);
  Set<String> getFavoriteKeys();
  List<TorrentRes> getTorrents();
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
