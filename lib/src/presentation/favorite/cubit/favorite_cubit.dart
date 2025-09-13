import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:torfin/src/data/models/response/torrent/torrent_res.dart';
import 'package:torfin/src/domain/usecases/add_torrent_use_case.dart';
import 'package:torfin/src/domain/usecases/favorite_use_case.dart';
import 'package:torfin/src/domain/usecases/get_magnet_use_case.dart';

import '../../../../core/helpers/data_state.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/models/response/empty_state/empty_state.dart';
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
    emit(
      state.copyWith(
        status: FavoriteStatus.loading,
        query: query,
        isShimmer: true,
      ),
    );
    final response = await _favoriteUseCase.call(
      const FavoriteParams(mode: FavoriteMode.getAll),
      cancelToken: CancelToken(),
    );
    response.when(
      success: (data) {
        final safe = data;
        final list = _filter(safe, query);
        final set = <String>{};
        if (safe.isNotEmpty) {
          for (int i = 0; i < safe.length; i++) {
            set.add(safe[i].identityKey);
          }
        }
        emit(
          state.copyWith(
            status: FavoriteStatus.success,
            all: safe,
            torrents: list,
            isShimmer: false,
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
            isShimmer: false,
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

  Future<void> toggleFavorite(TorrentRes torrent) async {
    final k = torrent.identityKey;
    final wasAdded = !state.favoriteKeys.contains(k);
    final next = wasAdded
        ? (state.favoriteKeys.toSet()..add(k))
        : (state.favoriteKeys.toSet()..remove(k));
    emit(state.copyWith(favoriteKeys: next));

    final response = await _favoriteUseCase(
      FavoriteParams(mode: FavoriteMode.toggle, torrent: torrent),
      cancelToken: CancelToken(),
    );
    response.when(
      success: (data) {
        final safe = data;
        final list = _filter(safe, state.query);
        final set = <String>{};
        if (safe.isNotEmpty) {
          for (int i = 0; i < safe.length; i++) {
            set.add(safe[i].identityKey);
          }
        }
        EmptyState emptyState;
        if (safe.isEmpty) {
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
            all: safe,
            torrents: list,
            isShimmer: false,
            favoriteKeys: set,
            emptyState: emptyState,
            notification: AppNotification(
              title: torrent.name,
              type: wasAdded
                  ? NotificationType.favoriteAdded
                  : NotificationType.favoriteRemoved,
              message: wasAdded ? wasAddedToFavorites : wasRemovedFromFavorites,
            ),
          ),
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
    _magnetCancelToken?.cancel('Dialog dismissed');
    _magnetCancelToken = null;
    if (!isClosed && state.fetchingMagnetForKey != null) {
      emit(state.copyWith(fetchingMagnetForKey: null));
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
          if (links.isNotEmpty) magnet = links.first;
        },
        failure: (error) {
          _magnetCancelToken = null;
          emit(
            state.copyWith(
              fetchingMagnetForKey: null,
              notification: AppNotification(
                title: torrent.name,
                type: NotificationType.error,
                message: error.message,
              ),
            ),
          );
        },
      );

      if (magnet == null || magnet!.isEmpty) {
        _magnetCancelToken = null;
        emit(
          state.copyWith(
            fetchingMagnetForKey: null,
            notification: AppNotification(
              title: torrent.name,
              type: NotificationType.error,
              message: magnetLinkNotFound,
            ),
          ),
        );
        return;
      }

      final addRes = await _addTorrentUseCase.call(
        AddTorrentUseCaseParams(magnetLink: magnet!),
        cancelToken: CancelToken(),
      );

      addRes.when(
        success: (_) {
          _magnetCancelToken = null;
          emit(
            state.copyWith(
              fetchingMagnetForKey: null,
              notification: AppNotification(
                title: torrent.name,
                type: NotificationType.downloadStarted,
                message: downloadStartedSuccessfully,
              ),
            ),
          );
        },
        failure: (error) {
          _magnetCancelToken = null;
          emit(
            state.copyWith(
              fetchingMagnetForKey: null,
              notification: AppNotification(
                title: torrent.name,
                type: NotificationType.error,
                message: '$failedToStartDownloadPrefix${error.message}',
              ),
            ),
          );
        },
      );
      return;
    }

    final response = await _addTorrentUseCase.call(
      AddTorrentUseCaseParams(
        magnetLink: torrent.magnet,
      ),
      cancelToken: CancelToken(),
    );

    response.when(
      success: (_) {
        emit(
          state.copyWith(
            notification: AppNotification(
              title: torrent.name,
              type: NotificationType.downloadStarted,
              message: downloadStartedSuccessfully,
            ),
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            notification: AppNotification(
              title: torrent.name,
              type: NotificationType.error,
              message: '$failedToStartDownloadPrefix${error.message}',
            ),
          ),
        );
      },
    );
  }
}
