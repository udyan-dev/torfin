part of 'favorite_cubit.dart';

enum FavoriteStatus { initial, success, error }

@freezed
sealed class FavoriteState with _$FavoriteState {
  const factory FavoriteState({
    @Default(FavoriteStatus.initial) FavoriteStatus status,
    @Default(EmptyState()) EmptyState emptyState,
    @Default(<TorrentRes>[]) List<TorrentRes> torrents,
    @Default(<TorrentRes>[]) List<TorrentRes> all,
    @Default('') String query,
    @Default(<String>{}) Set<String> favoriteKeys,
    AppNotification? notification,
    String? fetchingMagnetForKey,
  }) = _FavoriteState;
}

extension FavoriteStateEx on FavoriteState {
  bool isFavorite(TorrentRes t) => favoriteKeys.contains(t.identityKey);
}
