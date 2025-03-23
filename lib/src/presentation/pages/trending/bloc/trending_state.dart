part of 'trending_cubit.dart';

enum TrendingStateEnum { loading, ready, failure }

@freezed
abstract class TrendingState with _$TrendingState {
  const TrendingState._();

  const factory TrendingState({
    @Default(TrendingStateEnum.loading) TrendingStateEnum status,
    @Default(TorrentType.all) TorrentType torrentType,
    @Default(SortType.none) SortType sortType,
    @Default(TrendingType.day) TrendingType trendingType,
    @Default([]) List<TorrentRes> torrents,
    @Default(AppExceptionType.unknown) AppExceptionType error,
  }) = _TrendingState;
}
