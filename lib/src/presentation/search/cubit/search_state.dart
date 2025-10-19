part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, error }

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState({
    @Default(SearchStatus.initial) SearchStatus status,
    @Default(EmptyState()) EmptyState emptyState,
    @Default([]) List<TorrentRes> torrents,
    @Default([]) List<TorrentRes> rawTorrentList,
    @Default("") String search,
    @Default(0) int page,
    @Default(true) bool hasMore,
    @Default(SortType.none) SortType sortType,
    @Default(<String>[]) List<String> categoriesRaw,
    String? selectedCategoryRaw,
    @Default(false) bool isPaginating,
    @Default(false) bool isShimmer,
    String? currentRequestId,
    @Default(false) bool isAutoLoadingMore,
    @Default(<String>{}) Set<String> favoriteKeys,
    AppNotification? notification,
    String? fetchingMagnetForKey,
    @Default(false) bool isBulkOperationInProgress,
  }) = _SearchState;
}

extension SearchStateEx on SearchState {
  bool get isEmpty {
    if (torrents.isNotEmpty || status != SearchStatus.success) return false;
    return !isShimmer &&
        !isAutoLoadingMore &&
        !isPaginating &&
        !hasMore &&
        search.isNotEmpty;
  }

  bool get canLoadMore {
    if (!hasMore || isPaginating || isShimmer || isAutoLoadingMore) {
      return false;
    }
    return search.isNotEmpty &&
        status == SearchStatus.success &&
        currentRequestId != null;
  }

  bool get showLoadingMore => isPaginating && torrents.isNotEmpty;

  bool isFavorite(TorrentRes t) => favoriteKeys.contains(t.identityKey);
}
