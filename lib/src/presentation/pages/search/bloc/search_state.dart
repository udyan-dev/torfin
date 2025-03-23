part of 'search_cubit.dart';

enum SearchStateEnum { loading, ready, pagination, failure }

@freezed
abstract class SearchState with _$SearchState {
  const SearchState._();

  const factory SearchState({
    @Default(SearchStateEnum.ready) SearchStateEnum status,
    @Default(TorrentType.all) TorrentType torrentType,
    @Default(SortType.none) SortType sortType,
    @Default([]) List<TorrentRes> torrents,
    @Default("") String search,
    @Default(0) int page,
    @Default(true) bool hasMore,
    @Default(AppExceptionType.unknown) AppExceptionType error,
  }) = _SearchState;
}
