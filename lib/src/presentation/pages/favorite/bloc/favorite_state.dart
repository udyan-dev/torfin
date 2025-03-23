part of 'favorite_cubit.dart';

enum FavoriteStateEnum { loading, ready, failure }

@freezed
abstract class FavoriteState with _$FavoriteState {
  const FavoriteState._();

  const factory FavoriteState({
    @Default(FavoriteStateEnum.loading) FavoriteStateEnum status,
    @Default(TorrentType.all) TorrentType torrentType,
    @Default([]) List<TorrentRes> torrents,
    @Default("") String search,
    @Default(AppExceptionType.unknown) AppExceptionType error,
  }) = _FavoriteState;
}
