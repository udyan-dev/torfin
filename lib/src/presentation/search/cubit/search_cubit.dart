import 'dart:convert';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/helpers/base_exception.dart';
import '../../../../core/helpers/data_state.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/engine/engine.dart';
import '../../../../core/utils/utils.dart';
import '../../shared/notification_builders.dart';
import '../../../data/models/response/empty_state/empty_state.dart';

import '../../../data/models/response/torrent/torrent_res.dart';
import '../../../domain/repositories/storage_repository.dart';
import '../../../domain/usecases/add_torrent_use_case.dart';
import '../../../domain/usecases/auto_complete_use_case.dart';
import '../../../domain/usecases/favorite_use_case.dart';
import '../../../domain/usecases/get_magnet_use_case.dart';
import '../../../domain/usecases/search_torrent_use_case.dart';
import '../../widgets/notification_widget.dart';

part 'search_cubit.freezed.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required SearchTorrentUseCase searchTorrentUseCase,
    required AutoCompleteUseCase autoCompleteUseCase,
    required FavoriteUseCase favoriteUseCase,
    required AddTorrentUseCase addTorrentUseCase,
    required GetMagnetUseCase getMagnetUseCase,
    required StorageRepository storageRepository,
    ConnectivityService? connectivity,
  }) : _searchTorrentUseCase = searchTorrentUseCase,
       _autoCompleteUseCase = autoCompleteUseCase,
       _favoriteUseCase = favoriteUseCase,
       _addTorrentUseCase = addTorrentUseCase,
       _getMagnetUseCase = getMagnetUseCase,
       _storageRepository = storageRepository,
       _connectivity = connectivity ?? ConnectivityService(),
       super(const SearchState());

  final SearchTorrentUseCase _searchTorrentUseCase;
  final AutoCompleteUseCase _autoCompleteUseCase;
  final FavoriteUseCase _favoriteUseCase;
  final AddTorrentUseCase _addTorrentUseCase;
  final GetMagnetUseCase _getMagnetUseCase;
  final StorageRepository _storageRepository;
  final ConnectivityService _connectivity;
  CancelToken? _token;
  CancelToken? _suggestionToken;
  bool _isProcessingRequest = false;
  CancelToken? _magnetCancelToken;

  Timer? _liveSearchDebounce;

  @override
  Future<void> close() {
    _token?.cancel();
    _suggestionToken?.cancel();
    _magnetCancelToken?.cancel();
    _liveSearchDebounce?.cancel();
    return super.close();
  }

  void initializeWithAnimation() {
    emit(state.copyWith(status: SearchStatus.success));
  }

  Future<void> search({
    String? search,
    SortType? sortType,
    String? category,
    bool isRefresh = false,
  }) async {
    if (isClosed) return;

    if (state.favoriteKeys.isEmpty) await _syncFavorites();

    final newSearch = (search ?? state.search).trim();
    final newSortType = sortType ?? state.sortType;
    final newCategory = category ?? state.selectedCategoryRaw;

    if (newSearch.isEmpty) {
      _cancelCurrentRequest();
      return emit(_getInitialState(newSortType));
    }

    final searchChanged = newSearch != state.search;
    final sortChanged = newSortType != state.sortType;
    final categoryChanged = newCategory != state.selectedCategoryRaw;

    if (searchChanged || sortChanged || isRefresh) {
      return _performFreshSearch(newSearch, newSortType, newCategory);
    }

    if (categoryChanged) {
      return _handleCategoryChange(newCategory, newSortType);
    }
  }

  Future<void> _performFreshSearch(
    String search,
    SortType sortType,
    String? category,
  ) async {
    if (_isProcessingRequest) {
      _cancelCurrentRequest();
    }

    if (!await _connectivity.hasInternet) {
      final hasData = state.torrents.isNotEmpty;
      emit(
        state.copyWith(
          status: hasData ? SearchStatus.success : SearchStatus.error,
          search: search,
          sortType: sortType,
          selectedCategoryRaw: category,
          emptyState: const EmptyState(
            stateIcon: AppAssets.icNoNetwork,
            title: noInternetError,
            description: failedToConnectToServer,
            buttonText: retry,
          ),
          isPaginating: false,
          isShimmer: false,
          isAutoLoadingMore: false,
        ),
      );
      return;
    }

    _isProcessingRequest = true;
    _cancelCurrentRequest();
    final requestId = _generateRequestId();

    emit(
      state.copyWith(
        status: SearchStatus.loading,
        search: search,
        sortType: sortType,
        selectedCategoryRaw: category,
        torrents: [],
        rawTorrentList: [],
        page: 0,
        hasMore: true,
        isPaginating: false,
        isShimmer: true,
        isAutoLoadingMore: false,
        currentRequestId: requestId,
      ),
    );

    await _performApiCall(0, requestId);
  }

  Future<void> _handleCategoryChange(
    String? category,
    SortType sortType,
  ) async {
    _cancelCurrentRequest();

    if (state.status == SearchStatus.error || state.rawTorrentList.isEmpty) {
      return _performFreshSearch(state.search, sortType, category);
    }

    final filteredTorrents = _filterTorrentsByRaw(
      state.rawTorrentList,
      category,
    );

    emit(
      state.copyWith(
        status: SearchStatus.success,
        selectedCategoryRaw: category,
        sortType: sortType,
        torrents: filteredTorrents,
        isPaginating: false,
        isShimmer: false,
        isAutoLoadingMore: false,
      ),
    );

    final shouldAutoLoad =
        filteredTorrents.isEmpty && state.hasMore && !_isProcessingRequest;

    if (shouldAutoLoad) {
      if (!await _connectivity.hasInternet) {
        emit(
          state.copyWith(
            status: SearchStatus.success,
            isPaginating: false,
            isShimmer: false,
            isAutoLoadingMore: false,
            emptyState: const EmptyState(
              stateIcon: AppAssets.icNoNetwork,
              title: noInternetError,
              description: failedToConnectToServer,
              buttonText: retry,
            ),
          ),
        );
        return;
      }

      _isProcessingRequest = true;
      final requestId = _generateRequestId();

      emit(
        state.copyWith(
          status: SearchStatus.loading,
          isShimmer: true,
          isAutoLoadingMore: true,
          currentRequestId: requestId,
        ),
      );

      await _performApiCall(state.page + 1, requestId);
    }
  }

  Future<void> loadMore() async {
    if (isClosed ||
        !state.canLoadMore ||
        _isProcessingRequest ||
        state.currentRequestId == null) {
      return;
    }

    if (!await _connectivity.hasInternet) {
      emit(
        state.copyWith(
          status: SearchStatus.success,
          isPaginating: false,
          isShimmer: false,
          isAutoLoadingMore: false,
          hasMore: false,
          currentRequestId: null,
          emptyState: const EmptyState(
            stateIcon: AppAssets.icNoNetwork,
            title: noInternetError,
            description: failedToConnectToServer,
            buttonText: retry,
          ),
        ),
      );
      return;
    }

    _isProcessingRequest = true;

    emit(
      state.copyWith(
        isPaginating: state.torrents.isNotEmpty,
        isShimmer: state.torrents.isEmpty,
        isAutoLoadingMore: false,
      ),
    );

    await _performApiCall(state.page + 1, state.currentRequestId!);
  }

  Future<void> _autoLoadMore() async {
    if (isClosed ||
        !state.hasMore ||
        _isProcessingRequest ||
        state.currentRequestId == null) {
      return;
    }

    if (!await _connectivity.hasInternet) {
      emit(
        state.copyWith(
          status: SearchStatus.success,
          isPaginating: false,
          isShimmer: false,
          isAutoLoadingMore: false,
          emptyState: const EmptyState(
            stateIcon: AppAssets.icNoNetwork,
            title: noInternetError,
            description: failedToConnectToServer,
            buttonText: retry,
          ),
        ),
      );
      return;
    }

    _isProcessingRequest = true;

    emit(
      state.copyWith(
        status: SearchStatus.loading,
        isShimmer: true,
        isAutoLoadingMore: true,
      ),
    );

    await _performApiCall(state.page + 1, state.currentRequestId!);
  }

  Future<void> _performApiCall(int page, String requestId) async {
    if (isClosed || _token == null) {
      _isProcessingRequest = false;
      return;
    }

    try {
      final response = await _searchTorrentUseCase.call(
        SearchTorrentUseCaseParams(
          search: state.search,
          sort: state.sortType.value,
          page: page,
        ),
        cancelToken: _token!,
      );

      if (isClosed) {
        _isProcessingRequest = false;
        return;
      }

      if (state.currentRequestId != requestId) {
        _isProcessingRequest = false;
        return;
      }

      response.when(
        success: (torrents) => _handleApiSuccess(torrents, page, requestId),
        failure: (error) => _handleApiFailure(error),
      );
    } catch (e) {
      _isProcessingRequest = false;
      rethrow;
    }
  }

  void _handleApiSuccess(
    List<TorrentRes> newTorrents,
    int page,
    String requestId,
  ) {
    _isProcessingRequest = false;

    if (isClosed) return;

    if (state.currentRequestId != requestId) {
      return;
    }

    final isFirstPage = page == 0;
    final hasMoreData = newTorrents.isNotEmpty;

    final merged = <TorrentRes>[];
    final seenKeys = <String>{};
    String keyOf(TorrentRes t) {
      if (t.magnet.isNotEmpty) return 'm:${t.magnet}';
      if (t.url.isNotEmpty) return 'u:${t.url}';
      return 'n:${t.name}|${t.size}';
    }

    if (!isFirstPage) {
      for (int i = 0; i < state.rawTorrentList.length; i++) {
        final k = keyOf(state.rawTorrentList[i]);
        if (seenKeys.add(k)) merged.add(state.rawTorrentList[i]);
      }
    }
    for (int i = 0; i < newTorrents.length; i++) {
      final k = keyOf(newTorrents[i]);
      if (seenKeys.add(k)) merged.add(newTorrents[i]);
    }

    final oldSel = state.selectedCategoryRaw;
    final categoriesSeen = <String>{};

    List<TorrentRes> filtered = const <TorrentRes>[];
    String? firstCategory;
    bool oldSelPresent = false;

    if (oldSel == null || oldSel.isEmpty) {
      for (int i = 0; i < merged.length; i++) {
        final r = merged[i].type.trim();
        if (r.isNotEmpty) categoriesSeen.add(r);
      }
      filtered = merged;
      firstCategory = categoriesSeen.isEmpty ? null : all;
    } else {
      if (oldSel == all) {
        oldSelPresent = true;
        filtered = merged;
        for (int i = 0; i < merged.length; i++) {
          final r = merged[i].type.trim();
          if (r.isNotEmpty) categoriesSeen.add(r);
        }
      } else {
        filtered = <TorrentRes>[];
        for (int i = 0; i < merged.length; i++) {
          final r = merged[i].type.trim();
          if (r.isNotEmpty) {
            categoriesSeen.add(r);
            if (!oldSelPresent && r == oldSel) oldSelPresent = true;
          }
          if (r == oldSel) filtered.add(merged[i]);
        }
      }
    }

    final newCategoriesRaw = categoriesSeen.isEmpty
        ? const <String>[]
        : [all, ...categoriesSeen];

    final keepOldSelForNextPages =
        oldSel != null && oldSel.isNotEmpty && !oldSelPresent && hasMoreData;

    if (!oldSelPresent && !hasMoreData && oldSel != null && oldSel.isNotEmpty) {
      filtered = merged;
    }

    final newSelectedRaw = (oldSel == null || oldSel.isEmpty)
        ? firstCategory
        : (oldSelPresent ? oldSel : (keepOldSelForNextPages ? oldSel : null));

    final willAutoLoad =
        filtered.isEmpty && hasMoreData && newSelectedRaw != null;

    emit(
      state.copyWith(
        status: willAutoLoad ? SearchStatus.loading : SearchStatus.success,
        torrents: filtered,
        rawTorrentList: merged,
        page: page,
        hasMore: hasMoreData,
        isPaginating: false,
        isShimmer: willAutoLoad,
        isAutoLoadingMore: willAutoLoad,
        categoriesRaw: newCategoriesRaw,
        selectedCategoryRaw: newSelectedRaw,
      ),
    );

    if (willAutoLoad) {
      _autoLoadMore();
    }
  }

  void _handleApiFailure(BaseException error) {
    _isProcessingRequest = false;

    if (isClosed || error.type == BaseExceptionType.cancel) {
      return;
    }

    final hasExistingTorrents = state.torrents.isNotEmpty;

    final stopPagination = error.type != BaseExceptionType.cancel;

    emit(
      state.copyWith(
        status: hasExistingTorrents ? SearchStatus.success : SearchStatus.error,
        isPaginating: false,
        isShimmer: false,
        isAutoLoadingMore: false,
        hasMore: stopPagination ? false : hasExistingTorrents,
        currentRequestId: stopPagination ? null : state.currentRequestId,
        emptyState: EmptyState(
          stateIcon: AppAssets.icNoNetwork,
          title: error.message,
          description: failedToConnectToServer,
          buttonText: retry,
        ),
      ),
    );
  }

  String _generateRequestId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  void _cancelCurrentRequest() {
    _token?.cancel();
    _token = CancelToken();
    _isProcessingRequest = false;
  }

  List<TorrentRes> _filterTorrentsByRaw(
    List<TorrentRes> torrents,
    String? raw,
  ) {
    return filterByCategory<TorrentRes>(torrents, raw, (t) => t.type, all: all);
  }

  SearchState _getInitialState(SortType sortType) {
    return SearchState(sortType: sortType, status: SearchStatus.success);
  }

  Future<void> onRetry() async {
    if (isClosed || _isProcessingRequest) return;

    if (!await _connectivity.hasInternet) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
          emptyState: const EmptyState(
            stateIcon: AppAssets.icNoNetwork,
            title: noInternetError,
            description: failedToConnectToServer,
            buttonText: retry,
          ),
        ),
      );
      return;
    }

    if (state.search.isNotEmpty) {
      search(
        search: state.search,
        sortType: state.sortType,
        category: state.selectedCategoryRaw,
        isRefresh: true,
      );
    } else {
      emit(_getInitialState(state.sortType));
    }
  }

  Future<List<String>> fetchSuggestions(String query) async {
    if (isClosed) return const <String>[];

    final enableSuggestionsResult = await _storageRepository
        .getEnableSuggestions();
    final enableSuggestions = enableSuggestionsResult.data ?? true;

    if (!enableSuggestions) {
      _liveSearchDebounce?.cancel();
      _liveSearchDebounce = Timer(const Duration(milliseconds: 500), () {
        if (!isClosed) {
          search(search: query);
        }
      });
      return const <String>[];
    }

    _suggestionToken?.cancel();
    _suggestionToken = CancelToken();

    try {
      final response = await _autoCompleteUseCase.call(
        query,
        cancelToken: _suggestionToken!,
      );

      if (response is DataSuccess) {
        final jsonData = jsonDecode(response.data as String) as List<dynamic>;
        if (jsonData.length > 1 && jsonData[1] is List) {
          final suggestions = jsonData[1] as List<dynamic>;
          final result = <String>[];
          for (int i = 0; i < suggestions.length; i++) {
            result.add(suggestions[i].toString());
          }
          return result;
        }
      }

      return const <String>[];
    } catch (_) {
      return const <String>[];
    }
  }

  Future<void> _syncFavorites() async {
    final res = await _favoriteUseCase(
      const FavoriteParams(mode: FavoriteMode.getAll),
      cancelToken: CancelToken(),
    );
    res.when(
      success: (data) {
        final set = toKeySet<TorrentRes>(data, (t) => t.identityKey);
        emit(state.copyWith(favoriteKeys: set));
      },
    );
  }

  Future<void> toggleFavorite(TorrentRes torrent) async {
    final k = torrent.identityKey;
    final wasAdded = !state.favoriteKeys.contains(k);
    final next = toggleKey(state.favoriteKeys, k);
    emit(state.copyWith(favoriteKeys: next));
    final res = await _favoriteUseCase(
      FavoriteParams(mode: FavoriteMode.toggle, torrent: torrent),
      cancelToken: CancelToken(),
    );
    res.when(
      success: (data) {
        final set = toKeySet<TorrentRes>(data, (t) => t.identityKey);
        emit(
          state.copyWith(
            favoriteKeys: set,
            notification: favoriteNotification(torrent.name, wasAdded),
          ),
        );
      },
    );
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

      if (isClosed) return;

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
}
