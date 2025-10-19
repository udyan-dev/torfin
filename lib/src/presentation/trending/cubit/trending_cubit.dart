import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/helpers/base_exception.dart';
import '../../../../core/helpers/data_state.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../../core/utils/utils.dart';
import '../../../data/models/response/empty_state/empty_state.dart';
import '../../../data/models/response/torrent/torrent_res.dart';
import '../../../domain/usecases/add_torrent_use_case.dart';
import '../../../domain/usecases/favorite_use_case.dart';
import '../../../domain/usecases/get_magnet_use_case.dart';
import '../../../domain/usecases/trending_torrent_use_case.dart';
import '../../shared/torrent_cubit_mixin.dart';
import '../../widgets/notification_widget.dart';

part 'trending_cubit.freezed.dart';
part 'trending_state.dart';

class TrendingCubit extends Cubit<TrendingState> with TorrentCubitMixin {
  TrendingCubit({
    required TrendingTorrentUseCase trendingUseCase,
    required FavoriteUseCase favoriteUseCase,
    required AddTorrentUseCase addTorrentUseCase,
    required GetMagnetUseCase getMagnetUseCase,
    ConnectivityService? connectivity,
  }) : _trendingUseCase = trendingUseCase,
       _favoriteUseCase = favoriteUseCase,
       _addTorrentUseCase = addTorrentUseCase,
       _getMagnetUseCase = getMagnetUseCase,
       _connectivity = connectivity ?? ConnectivityService(),
       super(const TrendingState());

  final TrendingTorrentUseCase _trendingUseCase;
  final FavoriteUseCase _favoriteUseCase;
  final AddTorrentUseCase _addTorrentUseCase;
  final GetMagnetUseCase _getMagnetUseCase;
  final ConnectivityService _connectivity;
  CancelToken? _token;

  CancelToken? _magnetCancelToken;

  @override
  FavoriteUseCase get favoriteUseCase => _favoriteUseCase;

  @override
  AddTorrentUseCase get addTorrentUseCase => _addTorrentUseCase;

  @override
  GetMagnetUseCase get getMagnetUseCase => _getMagnetUseCase;

  @override
  Future<void> close() {
    _token?.cancel();
    _magnetCancelToken?.cancel();
    return super.close();
  }

  Future<void> trending({
    TrendingType? type,
    SortType? sortType,
    String? category,
    bool isRefresh = false,
  }) async {
    if (isClosed) return;

    if (state.favoriteKeys.isEmpty) await _syncFavorites();

    final newType = type ?? state.trendingType;
    final newSort = sortType ?? state.sortType;
    final newCategory = category ?? state.selectedCategoryRaw;

    final typeChanged = newType != state.trendingType;
    final sortChanged = newSort != state.sortType;
    final categoryChanged = newCategory != state.selectedCategoryRaw;

    if (sortChanged || isRefresh) {
      if (sortChanged && state.cacheByType.isNotEmpty) {
        emit(state.copyWith(cacheByType: const {}));
      }
      return _fetch(newType, newSort, newCategory);
    }

    if (typeChanged) {
      final cached = state.cacheByType[newType];
      if (cached != null && cached.isNotEmpty) {
        return _emitFromCache(newType, newSort, cached);
      }
      return _fetch(newType, newSort, newCategory);
    }

    if (categoryChanged) {
      return _filterCategory(newCategory, newSort);
    }
  }

  Future<void> _fetch(
    TrendingType type,
    SortType sort,
    String? category,
  ) async {
    if (!await _connectivity.hasInternet) {
      final hasData = state.torrents.isNotEmpty;
      emit(
        state.copyWith(
          status: hasData ? TrendingStatus.success : TrendingStatus.error,
          trendingType: type,
          sortType: sort,
          selectedCategoryRaw: category,
          emptyState: const EmptyState(
            stateIcon: AppAssets.icNoNetwork,
            title: noInternetError,
            description: failedToConnectToServer,
            buttonText: retry,
          ),
          isShimmer: false,
        ),
      );
      return;
    }

    _token?.cancel();
    _token = CancelToken();

    emit(
      state.copyWith(
        status: TrendingStatus.loading,
        trendingType: type,
        sortType: sort,
        selectedCategoryRaw: category,
        torrents: const [],
        rawTorrentList: const [],
        isShimmer: true,
      ),
    );

    try {
      final response = await _trendingUseCase.call(
        TrendingTorrentUseCaseParams(
          sort: sort.value,
          top: type.value,
          nsfw: '',
        ),
        cancelToken: _token!,
      );

      if (isClosed) {
        return;
      }

      switch (response) {
        case DataSuccess<List<TorrentRes>>(:final data):
          _handleSuccess(type, sort, data as List<TorrentRes>);
        case DataFailed<List<TorrentRes>>(:final error):
          _handleFailure(type, sort, error!);
        case DataNotSet<List<TorrentRes>>():
          return;
      }
    } catch (e) {
      rethrow;
    }
  }

  void _handleSuccess(
    TrendingType type,
    SortType sort,
    List<TorrentRes> newTorrents,
  ) {
    if (isClosed) return;

    final categoriesSeen = <String>{};
    final out = <TorrentRes>[];
    for (int i = 0; i < newTorrents.length; i++) {
      final t = newTorrents[i];
      final r = t.type.trim();
      if (r.isNotEmpty) categoriesSeen.add(r);
      out.add(t);
    }

    final oldSel = state.selectedCategoryRaw;
    final hasOld = oldSel != null && oldSel.isNotEmpty;
    bool oldPresent = false;
    if (hasOld) {
      if (oldSel == all) {
        oldPresent = true;
      } else {
        for (int i = 0; i < out.length; i++) {
          if (out[i].type.trim() == oldSel) {
            oldPresent = true;
            break;
          }
        }
      }
    }

    final newCategoriesRaw = categoriesSeen.isEmpty
        ? const <String>[]
        : [all, ...categoriesSeen];

    List<TorrentRes> filtered;
    String? newSelectedRaw;
    if (!hasOld) {
      if (newCategoriesRaw.isEmpty) {
        filtered = out;
        newSelectedRaw = null;
      } else {
        newSelectedRaw = newCategoriesRaw.first;
        filtered = _filter(out, newSelectedRaw);
      }
    } else {
      filtered = oldPresent ? _filter(out, oldSel) : out;
      newSelectedRaw = oldPresent ? oldSel : null;
    }

    emit(
      state.copyWith(
        status: TrendingStatus.success,
        trendingType: type,
        sortType: sort,
        torrents: filtered,
        rawTorrentList: out,
        isShimmer: false,
        categoriesRaw: newCategoriesRaw,
        selectedCategoryRaw: newSelectedRaw,
        cacheByType: {...state.cacheByType, type: out},
      ),
    );
  }

  void _handleFailure(TrendingType type, SortType sort, BaseException error) {
    if (isClosed || error.type == BaseExceptionType.cancel) return;

    emit(
      state.copyWith(
        status: TrendingStatus.error,
        isShimmer: false,
        trendingType: type,
        sortType: sort,
        emptyState: EmptyState(
          stateIcon: AppAssets.icNoNetwork,
          title: error.message,
          description: failedToConnectToServer,
          buttonText: retry,
        ),
      ),
    );
  }

  void _emitFromCache(TrendingType type, SortType sort, List<TorrentRes> raw) {
    final categories = <String>{};
    for (int i = 0; i < raw.length; i++) {
      final r = raw[i].type.trim();
      if (r.isNotEmpty) categories.add(r);
    }
    final cats = categories.isEmpty ? const <String>[] : [all, ...categories];
    final sel = cats.isNotEmpty ? cats.first : null;
    emit(
      state.copyWith(
        status: TrendingStatus.success,
        trendingType: type,
        sortType: sort,
        isShimmer: false,
        torrents: sel == null ? raw : _filter(raw, sel),
        rawTorrentList: raw,
        categoriesRaw: cats,
        selectedCategoryRaw: sel,
      ),
    );
  }

  Future<void> _filterCategory(String? category, SortType sort) async {
    if (state.status == TrendingStatus.error || state.rawTorrentList.isEmpty) {
      return _fetch(state.trendingType, sort, category);
    }

    final filtered = _filter(state.rawTorrentList, category);

    emit(
      state.copyWith(
        status: TrendingStatus.success,
        selectedCategoryRaw: category,
        sortType: sort,
        torrents: filtered,
        isShimmer: false,
      ),
    );
  }

  List<TorrentRes> _filter(List<TorrentRes> list, String? raw) {
    return filterByCategory<TorrentRes>(list, raw, (t) => t.type, all: all);
  }

  Future<void> _syncFavorites() async => syncFavorites();

  Future<void> toggleFavorite(TorrentRes torrent) async =>
      toggleFavoriteImpl(torrent);

  void cancelMagnetFetch() => cancelMagnetFetchImpl();

  Future<void> downloadTorrent(TorrentRes torrent) async =>
      downloadTorrentImpl(torrent);

  Future<void> addMultipleToFavorites(Set<String> keys) async {
    if (keys.isEmpty) return;

    final torrentsToAdd = state.torrents
        .where((t) => keys.contains(t.identityKey))
        .toList();

    if (torrentsToAdd.isEmpty) return;

    emit(state.copyWith(isBulkOperationInProgress: true));

    final result = await _favoriteUseCase.callBatch(torrentsToAdd);

    final response = await _favoriteUseCase(
      const FavoriteParams(mode: FavoriteMode.getAll),
      cancelToken: CancelToken(),
    );

    final favoriteKeys = response.data != null
        ? toKeySet<TorrentRes>(response.data!, (t) => t.identityKey)
        : state.favoriteKeys;

    final notificationType = result.isError
        ? NotificationType.error
        : result.hasPartialSuccess
        ? NotificationType.partialSuccess
        : NotificationType.favoriteAdded;

    emit(
      state.copyWith(
        favoriteKeys: favoriteKeys,
        isBulkOperationInProgress: false,
        notification: AppNotification(
          title: result.title,
          message: result.message ?? '',
          type: notificationType,
        ),
      ),
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
    emit(state.copyWith(favoriteKeys: keys));
  }

  @override
  void emitWithFavoriteKeysAndNotification(
    Set<String> keys,
    AppNotification notification,
  ) {
    emit(state.copyWith(favoriteKeys: keys, notification: notification));
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
