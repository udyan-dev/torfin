import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/helpers/data_state.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/engine/engine.dart';
import '../../../../core/utils/utils.dart';
import '../../../data/models/response/empty_state/empty_state.dart';
import '../../../data/models/response/torrent/torrent_res.dart';
import '../../../domain/usecases/add_torrent_use_case.dart';
import '../../../domain/usecases/favorite_use_case.dart';
import '../../../domain/usecases/get_magnet_use_case.dart';
import '../../shared/notification_builders.dart';
import '../../widgets/notification_widget.dart';

part 'favorite_cubit.freezed.dart';
part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({
    required FavoriteUseCase favoriteUseCase,
    required AddTorrentUseCase addTorrentUseCase,
    required GetMagnetUseCase getMagnetUseCase,
  }) : _favoriteUseCase = favoriteUseCase,
       _addTorrentUseCase = addTorrentUseCase,
       _getMagnetUseCase = getMagnetUseCase,
       super(const FavoriteState());

  final FavoriteUseCase _favoriteUseCase;
  final AddTorrentUseCase _addTorrentUseCase;
  final GetMagnetUseCase _getMagnetUseCase;

  CancelToken? _magnetCancelToken;

  @override
  Future<void> close() {
    _magnetCancelToken?.cancel();
    return super.close();
  }

  Future<void> load({String query = ''}) async {
    final response = await _favoriteUseCase.call(
      const FavoriteParams(mode: FavoriteMode.getAll),
      cancelToken: CancelToken(),
    );
    response.when(
      success: (data) {
        final safe = data;
        final list = _filter(safe, query);
        final set = toKeySet<TorrentRes>(safe, (t) => t.identityKey);
        emit(
          state.copyWith(
            status: FavoriteStatus.success,
            all: safe,
            torrents: list,
            favoriteKeys: set,
            emptyState: list.isEmpty
                ? (query.isEmpty
                      ? const EmptyState(
                          stateIcon: AppAssets.icAddFavorite,
                          title: saveYourFavoriteTorrents,
                          description: addTorrentsToYourFavorites,
                        )
                      : const EmptyState(
                          stateIcon: AppAssets.icNoResultFound,
                          title: noResultsFoundTitle,
                          description: noResultsFoundDescription,
                        ))
                : const EmptyState(),
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: FavoriteStatus.error,
            emptyState: EmptyState(
              stateIcon: AppAssets.icNoNetwork,
              title: error.message,
              description: failedToConnectToServer,
              buttonText: retry,
            ),
          ),
        );
      },
    );
  }

  void _updateStateWithFavorites(
    List<TorrentRes> favorites, {
    AppNotification? notification,
    bool isBulkOperationInProgress = false,
  }) {
    final list = _filter(favorites, state.query);
    final set = toKeySet<TorrentRes>(favorites, (t) => t.identityKey);
    EmptyState emptyState;
    if (favorites.isEmpty) {
      emptyState = const EmptyState(
        stateIcon: AppAssets.icAddFavorite,
        title: saveYourFavoriteTorrents,
        description: addTorrentsToYourFavorites,
      );
    } else if (list.isEmpty && state.query.isNotEmpty) {
      emptyState = const EmptyState(
        stateIcon: AppAssets.icNoResultFound,
        title: noResultsFoundTitle,
        description: noResultsFoundDescription,
      );
    } else {
      emptyState = const EmptyState();
    }
    emit(
      state.copyWith(
        status: FavoriteStatus.success,
        all: favorites,
        torrents: list,
        favoriteKeys: set,
        emptyState: emptyState,
        isBulkOperationInProgress: isBulkOperationInProgress,
        notification: notification,
      ),
    );
  }

  Future<void> toggleFavorite(TorrentRes torrent) async {
    final k = torrent.identityKey;
    final wasAdded = !state.favoriteKeys.contains(k);
    final next = toggleKey(state.favoriteKeys, k);
    emit(state.copyWith(favoriteKeys: next));

    final response = await _favoriteUseCase(
      FavoriteParams(mode: FavoriteMode.toggle, torrent: torrent),
      cancelToken: CancelToken(),
    );
    response.when(
      success: (data) {
        _updateStateWithFavorites(
          data,
          notification: favoriteNotification(torrent.name, wasAdded),
        );
      },
    );
  }

  List<TorrentRes> _filter(List<TorrentRes> list, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return list;
    final out = <TorrentRes>[];
    for (int i = 0; i < list.length; i++) {
      final t = list[i];
      final name = t.name.toLowerCase();
      if (name.contains(q)) out.add(t);
    }
    return out;
  }

  void cancelMagnetFetch() {
    _magnetCancelToken?.cancel();
    _magnetCancelToken = null;
    if (!isClosed) {
      if (state.fetchingMagnetForKey != null) {
        emit(state.copyWith(fetchingMagnetForKey: null));
      }
      if (state.isBulkOperationInProgress) {
        emit(state.copyWith(isBulkOperationInProgress: false));
      }
    }
  }

  Future<void> downloadTorrent(TorrentRes torrent) async {
    final key = torrent.identityKey;
    if (torrent.magnet.isEmpty) {
      emit(state.copyWith(fetchingMagnetForKey: key));

      _magnetCancelToken = CancelToken();
      final res = await _getMagnetUseCase.call(
        torrent.url,
        cancelToken: _magnetCancelToken!,
      );

      String? magnet;
      res.when(
        success: (links) {
          magnet = firstOrNull<String>(links);
        },
        failure: (error) {
          _magnetCancelToken = null;
          emit(
            state.copyWith(
              fetchingMagnetForKey: null,
              notification: errorNotification(torrent.name, error.message),
            ),
          );
        },
      );

      if (magnet == null || magnet!.isEmpty) {
        _magnetCancelToken = null;
        emit(
          state.copyWith(
            fetchingMagnetForKey: null,
            notification: magnetNotFoundNotification(torrent.name),
          ),
        );
        return;
      }

      final addRes = await _addTorrentUseCase.call(
        AddTorrentUseCaseParams(magnetLink: magnet!),
        cancelToken: CancelToken(),
      );

      addRes.when(
        success: (response) {
          _magnetCancelToken = null;
          final isDuplicate = response == TorrentAddedResponse.duplicated;
          emit(
            state.copyWith(
              fetchingMagnetForKey: null,
              notification: addStartedNotification(torrent.name, isDuplicate),
            ),
          );
        },
        failure: (error) {
          _magnetCancelToken = null;
          emit(
            state.copyWith(
              fetchingMagnetForKey: null,
              notification: addFailedNotification(torrent.name, error.message),
            ),
          );
        },
      );
      return;
    }

    final response = await _addTorrentUseCase.call(
      AddTorrentUseCaseParams(magnetLink: torrent.magnet),
      cancelToken: CancelToken(),
    );

    response.when(
      success: (response) {
        final isDuplicate = response == TorrentAddedResponse.duplicated;
        emit(
          state.copyWith(
            notification: addStartedNotification(torrent.name, isDuplicate),
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            notification: addFailedNotification(torrent.name, error.message),
          ),
        );
      },
    );
  }

  Future<void> removeMultipleFromFavorites(Set<String> keys) async {
    if (keys.isEmpty) return;

    emit(state.copyWith(isBulkOperationInProgress: true));

    final torrentsToRemove = state.all
        .where((t) => keys.contains(t.identityKey))
        .toList();

    if (torrentsToRemove.isEmpty) {
      emit(state.copyWith(isBulkOperationInProgress: false));
      return;
    }

    final response = await _favoriteUseCase(
      FavoriteParams(
        mode: FavoriteMode.removeMultiple,
        torrents: torrentsToRemove,
      ),
      cancelToken: CancelToken(),
    );

    response.when(
      success: (data) {
        _updateStateWithFavorites(
          data,
          notification: bulkRemoveSuccessNotification(torrentsToRemove.length),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            isBulkOperationInProgress: false,
            notification: bulkRemoveFailedNotification(error.message),
          ),
        );
      },
    );
  }

  Future<void> downloadMultipleTorrents(Set<String> keys) async {
    if (keys.isEmpty) return;

    final torrentsToDownload = state.torrents
        .where((t) => keys.contains(t.identityKey))
        .toList();

    if (torrentsToDownload.isEmpty) return;

    emit(state.copyWith(isBulkOperationInProgress: true));

    _magnetCancelToken?.cancel();
    _magnetCancelToken = CancelToken();

    int successCount = 0;
    int failureCount = 0;

    for (int i = 0; i < torrentsToDownload.length; i++) {
      if (_magnetCancelToken?.isCancelled ?? true) break;

      final torrent = torrentsToDownload[i];
      String? magnetLink = torrent.magnet;

      if (magnetLink.isEmpty) {
        final res = await _getMagnetUseCase.call(
          torrent.url,
          cancelToken: _magnetCancelToken!,
        );
        res.when(
          success: (links) {
            if (links.isNotEmpty) magnetLink = links.first;
          },
          failure: (_) {
            magnetLink = null;
          },
        );
      }

      if (magnetLink == null || magnetLink!.isEmpty) {
        failureCount++;
        continue;
      }

      final response = await _addTorrentUseCase.call(
        AddTorrentUseCaseParams(magnetLink: magnetLink!),
        cancelToken: _magnetCancelToken!,
      );

      response.when(
        success: (res) {
          if (res == TorrentAddedResponse.duplicated) {
            failureCount++;
          } else {
            successCount++;
          }
        },
        failure: (_) => failureCount++,
      );
    }

    if (_magnetCancelToken?.isCancelled ?? true) {
      emit(state.copyWith(isBulkOperationInProgress: false));
      _magnetCancelToken = null;
      return;
    }

    _magnetCancelToken = null;

    String title;
    String message;
    NotificationType notificationType;

    if (successCount > 0 && failureCount > 0) {
      title =
          '$successCount $successSuffix, $failureCount $failedToDownloadTorrents';
      message = emptyString;
      notificationType = NotificationType.downloadStarted;
    } else if (successCount > 0) {
      title = '$successCount $torrentsWereAddedToDownload';
      message = emptyString;
      notificationType = NotificationType.downloadStarted;
    } else {
      title = '$failureCount $failedToDownloadTorrents';
      message = emptyString;
      notificationType = NotificationType.error;
    }

    emit(
      state.copyWith(
        isBulkOperationInProgress: false,
        notification: AppNotification(
          title: title,
          type: notificationType,
          message: message,
        ),
      ),
    );
  }
}
