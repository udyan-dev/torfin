import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:torfin/src/data/models/response/torrent/torrent_res.dart';
import 'package:torfin/src/domain/usecases/search_torrent_use_case.dart';

import '../../../../core/helpers/base_exception.dart';
import '../../../../core/helpers/data_state.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/models/response/empty_state/empty_state.dart';
import '../../../domain/usecases/auto_complete_use_case.dart';

part 'search_cubit.freezed.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required SearchTorrentUseCase searchTorrentUseCase,
    required AutoCompleteUseCase autoCompleteUseCase,
    ConnectivityService? connectivity,
  }) : _searchTorrentUseCase = searchTorrentUseCase,
       _autoCompleteUseCase = autoCompleteUseCase,
       _connectivity = connectivity ?? ConnectivityService(),
       super(const SearchState());

  final SearchTorrentUseCase _searchTorrentUseCase;
  final AutoCompleteUseCase _autoCompleteUseCase;
  final ConnectivityService _connectivity;
  CancelToken? _token;
  CancelToken? _suggestionToken;
  bool _isProcessingRequest = false;

  @override
  Future<void> close() {
    _token?.cancel();
    _suggestionToken?.cancel();
    return super.close();
  }

  Future<void> search({
    String? search,
    SortType? sortType,
    String? category,
    bool isRefresh = false,
  }) async {
    if (isClosed) return;

    final newSearch = (search ?? state.search).trim();
    final newSortType = sortType ?? state.sortType;
    final newCategory = category ?? state.selectedCategoryRaw;

    log(
      'SEARCH: query="$newSearch" sort=$newSortType category=$newCategory refresh=$isRefresh',
    );

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

    log(
      'FRESH_SEARCH: start query="$search" sort=$sortType category=$category id=$requestId',
    );

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
      log('CATEGORY_CHANGE: no_data - performing fresh search');
      return _performFreshSearch(state.search, sortType, category);
    }

    final filteredTorrents = _filterTorrentsByRaw(
      state.rawTorrentList,
      category,
    );
    log(
      'CATEGORY_CHANGE: raw="$category" filtered=${filteredTorrents.length}/${state.rawTorrentList.length}',
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
      log(
        'CATEGORY_CHANGE: auto_load start page=${state.page + 1} id=$requestId',
      );

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
      log(
        'LOAD_MORE: blocked - closed=$isClosed canLoad=${state.canLoadMore} processing=$_isProcessingRequest',
      );
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
    log('LOAD_MORE: start page=${state.page + 1} id=${state.currentRequestId}');

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
    log('AUTO_LOAD: start page=${state.page + 1} id=${state.currentRequestId}');

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

    log(
      'API_CALL: page=$page id=$requestId query="${state.search}" sort=${state.sortType.value}',
    );

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
        log(
          'API_RESPONSE: ignored - stale request current=${state.currentRequestId} received=$requestId',
        );
        _isProcessingRequest = false;
        return;
      }

      response.when(
        success: (torrents) => _handleApiSuccess(torrents, page, requestId),
        failure: (error) => _handleApiFailure(error),
      );
    } catch (e) {
      _isProcessingRequest = false;
      log('API_CALL: exception - $e');
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
      log(
        'API_SUCCESS: ignored - request mismatch current=${state.currentRequestId} received=$requestId',
      );
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
        if (r.isNotEmpty && categoriesSeen.add(r) && firstCategory == null) {
          firstCategory = r;
        }
      }

      if (firstCategory == null) {
        filtered = merged;
      } else {
        final out = <TorrentRes>[];
        for (int i = 0; i < merged.length; i++) {
          if (merged[i].type.trim() == firstCategory) out.add(merged[i]);
        }
        filtered = out;
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

    final newCategoriesRaw = categoriesSeen.isEmpty
        ? const <String>[]
        : List<String>.from(categoriesSeen, growable: false);

    final keepOldSelForNextPages =
        oldSel != null && oldSel.isNotEmpty && !oldSelPresent && hasMoreData;

    if (!oldSelPresent && !hasMoreData && oldSel != null && oldSel.isNotEmpty) {
      filtered = merged;
    }

    final newSelectedRaw = (oldSel == null || oldSel.isEmpty)
        ? firstCategory
        : (oldSelPresent ? oldSel : (keepOldSelForNextPages ? oldSel : null));

    log(
      'API_SUCCESS: page=$page new=${newTorrents.length} raw=${state.rawTorrentList.length}->${merged.length} filtered=${filtered.length} hasMore=$hasMoreData',
    );

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
      log('API_SUCCESS: triggering auto-load');
      _autoLoadMore();
    }
  }

  void _handleApiFailure(BaseException error) {
    _isProcessingRequest = false;

    if (isClosed || error.type == BaseExceptionType.cancel) {
      log('API_FAILURE: ignored - closed=$isClosed type=${error.type}');
      return;
    }

    final hasExistingTorrents = state.torrents.isNotEmpty;
    log(
      'API_FAILURE: error="${error.message}" type=${error.type} hasData=$hasExistingTorrents',
    );

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
    final cr = raw?.trim();
    if (cr == null || cr.isEmpty) return torrents;

    final out = <TorrentRes>[];
    for (int i = 0; i < torrents.length; i++) {
      if (torrents[i].type.trim() == cr) out.add(torrents[i]);
    }
    return out;
  }

  SearchState _getInitialState(SortType sortType) {
    return SearchState(sortType: sortType);
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

    log('RETRY: query="${state.search}"');

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
}
