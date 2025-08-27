part of 'trending_cubit.dart';

enum TrendingStatus { initial, loading, success, error }

@freezed
sealed class TrendingState with _$TrendingState {
  const factory TrendingState({
    @Default(TrendingStatus.initial) TrendingStatus status,
    @Default(EmptyState()) EmptyState emptyState,
    @Default(<TorrentRes>[]) List<TorrentRes> torrents,
    @Default(<TorrentRes>[]) List<TorrentRes> rawTorrentList,
    @Default(SortType.none) SortType sortType,
    @Default(<String>[]) List<String> categoriesRaw,
    String? selectedCategoryRaw,
    @Default(false) bool isShimmer,
    @Default(TrendingType.day) TrendingType trendingType,
    @Default(<TrendingType, List<TorrentRes>>{})
    Map<TrendingType, List<TorrentRes>> cacheByType,
  }) = _TrendingState;
}

enum TrendingType {
  day("24", "Today"),
  week("168", "This Week"),
  month("720", "This Month");

  final String value;
  final String title;

  const TrendingType(this.value, this.title);
}

extension TrendingStateX on TrendingState {
  bool get isEmpty =>
      status == TrendingStatus.success && torrents.isEmpty && !isShimmer;
}
