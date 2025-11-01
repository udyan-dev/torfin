import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/helpers/data_state.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../../core/utils/utils.dart';
import '../../../data/models/response/empty_state/empty_state.dart';
import '../../../data/models/response/torrent/torrent_res.dart';
import '../../../domain/usecases/add_torrent_use_case.dart';
import '../../../domain/usecases/favorite_use_case.dart';
import '../../../domain/usecases/get_magnet_use_case.dart';
import '../../../domain/usecases/share_torrent_use_case.dart';
import '../../shared/notification_builders.dart';
import '../../shared/torrent_cubit_mixin.dart';
import '../../widgets/notification_widget.dart';

part 'favorite_cubit.freezed.dart';
part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> with TorrentCubitMixin {
  FavoriteCubit({
    required FavoriteUseCase favoriteUseCase,
    required AddTorrentUseCase addTorrentUseCase,
    required GetMagnetUseCase getMagnetUseCase,
    required ShareTorrentUseCase shareTorrentUseCase,
  }) : _favoriteUseCase = favoriteUseCase,
       _addTorrentUseCase = addTorrentUseCase,
       _getMagnetUseCase = getMagnetUseCase,
       _shareTorrentUseCase = shareTorrentUseCase,
       super(const FavoriteState());

  final FavoriteUseCase _favoriteUseCase;
  final AddTorrentUseCase _addTorrentUseCase;
  final GetMagnetUseCase _getMagnetUseCase;
  final ShareTorrentUseCase _shareTorrentUseCase;

  CancelToken? _magnetCancelToken;

  @override
  FavoriteUseCase get favoriteUseCase => _favoriteUseCase;

  @override
  AddTorrentUseCase get addTorrentUseCase => _addTorrentUseCase;

  @override
  GetMagnetUseCase get getMagnetUseCase => _getMagnetUseCase;

  @override
  ShareTorrentUseCase get shareTorrentUseCase => _shareTorrentUseCase;

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

  Future<void> toggleFavorite(TorrentRes torrent) async =>
      toggleFavoriteImpl(torrent);

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

  void cancelMagnetFetch() => cancelMagnetFetchImpl();

  Future<void> downloadTorrent(
    TorrentRes torrent,
    BuildContext context,
  ) async => downloadTorrentImpl(torrent, context);

  Future<void> shareTorrent(
    TorrentRes torrent,
    BuildContext dialogContext,
  ) async => shareTorrentImpl(torrent, dialogContext);

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

    final items = state.torrents
        .where((t) => keys.contains(t.identityKey))
        .map((t) => BatchTorrentItem(url: t.url, magnet: t.magnet))
        .toList();

    if (items.isEmpty) return;

    emit(state.copyWith(isBulkOperationInProgress: true));

    _magnetCancelToken?.cancel();
    _magnetCancelToken = CancelToken();

    final result = await _addTorrentUseCase.callBatch(
      items,
      _magnetCancelToken!,
    );

    if (_magnetCancelToken?.isCancelled ?? true) {
      emit(state.copyWith(isBulkOperationInProgress: false));
      _magnetCancelToken = null;
      return;
    }

    _magnetCancelToken = null;

    final notificationType = result.isError
        ? NotificationType.error
        : result.hasPartialSuccess
        ? NotificationType.partialSuccess
        : NotificationType.downloadStarted;

    emit(
      state.copyWith(
        isBulkOperationInProgress: false,
        notification: AppNotification(
          title: result.title,
          message: result.message,
          type: notificationType,
        ),
      ),
    );
  }

  @override
  bool isFavorite(String key) => state.favoriteKeys.contains(key);

  @override
  Set<String> getFavoriteKeys() => state.favoriteKeys;

  @override
  CancelToken? getMagnetCancelToken() => _magnetCancelToken;

  @override
  void setMagnetCancelToken(CancelToken? token) {
    _magnetCancelToken = token;
  }

  @override
  String? getFetchingMagnetForKey() => state.fetchingMagnetForKey;

  @override
  void emitWithFavoriteKeys(Set<String> keys) {
    _updateStateWithFavorites(
      state.all.where((t) => keys.contains(t.identityKey)).toList(),
    );
  }

  @override
  void emitWithFavoriteKeysAndNotification(
    Set<String> keys,
    AppNotification notification,
  ) {
    _updateStateWithFavorites(
      state.all.where((t) => keys.contains(t.identityKey)).toList(),
      notification: notification,
    );
  }

  @override
  void emitFetchingMagnet(String? key) {
    emit(state.copyWith(fetchingMagnetForKey: key));
  }

  @override
  void emitFetchingMagnetWithNotification(
    String? key,
    AppNotification notification,
  ) {
    emit(state.copyWith(fetchingMagnetForKey: key, notification: notification));
  }

  @override
  void emitNotification(AppNotification notification) {
    emit(state.copyWith(notification: notification));
  }
}
