import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:torfin/src/data/models/response/torrent/torrent_res.dart';
import 'package:torfin/src/domain/usecases/trending_torrent_use_case.dart';

import '../../../../core/helpers/base_exception.dart';
import '../../../../core/helpers/data_state.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/models/response/empty_state/empty_state.dart';
import '../../../domain/usecases/favorite_use_case.dart';
import '../../widgets/notification_widget.dart';

part 'trending_cubit.freezed.dart';

part 'trending_state.dart';

class TrendingCubit extends Cubit<TrendingState> {
  TrendingCubit({
    required TrendingTorrentUseCase trendingUseCase,
    required FavoriteUseCase favoriteUseCase,
    ConnectivityService? connectivity,
  }) : _trendingUseCase = trendingUseCase,
       _favoriteUseCase = favoriteUseCase,
       _connectivity = connectivity ?? ConnectivityService(),
       super(const TrendingState());

  final TrendingTorrentUseCase _trendingUseCase;
  final FavoriteUseCase _favoriteUseCase;
  final ConnectivityService _connectivity;
  CancelToken? _token;

  @override
  Future<void> close() {
    _token?.cancel();
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

    log(
      'TRENDING: type=${newType.name} sort=$newSort category=$newCategory refresh=$isRefresh',
    );

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
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    log(
      'TRENDING_FETCH: start type=${type.name} sort=$sort category=$category id=$requestId',
    );

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
      log('TRENDING_FETCH: exception - $e');
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
      for (int i = 0; i < out.length; i++) {
        if (out[i].type.trim() == oldSel) {
          oldPresent = true;
          break;
        }
      }
    }

    final newCategoriesRaw = categoriesSeen.isEmpty
        ? const <String>[]
        : List<String>.from(categoriesSeen, growable: false);

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
    final cats = categories.isEmpty
        ? const <String>[]
        : List<String>.from(categories, growable: false);
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
      log('TRENDING_CATEGORY: no_data - refetch');
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
    final cr = raw?.trim();
    if (cr == null || cr.isEmpty) return list;
    final out = <TorrentRes>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i].type.trim() == cr) out.add(list[i]);
    }
    return out;
  }

  Future<void> _syncFavorites() async {
    final res = await _favoriteUseCase(
      const FavoriteParams(mode: FavoriteMode.getAll),
      cancelToken: CancelToken(),
    );
    res.when(
      success: (data) {
        final set = <String>{};
        if (data.isNotEmpty) {
          for (int i = 0; i < data.length; i++) {
            set.add(data[i].identityKey);
          }
        }
        emit(state.copyWith(favoriteKeys: set));
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
        final set = <String>{};
        if (data.isNotEmpty) {
          for (int i = 0; i < data.length; i++) {
            set.add(data[i].identityKey);
          }
        }
        emit(
          state.copyWith(
            favoriteKeys: set,
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
}
