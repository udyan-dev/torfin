part of 'coins_cubit.dart';

@freezed
sealed class CoinsState with _$CoinsState {
  const factory CoinsState({@Default(initialCoins) int coins}) = _CoinsState;
}

extension CoinsStateEx on CoinsState {
  bool get canWatchAd => coins == 0;
  bool get canDownload => coins > 0;
}
