part of 'home_cubit.dart';

enum HomeStateEnum {
  initial,
  indexChanged,
  permissionGranted,
  permissionDenied,
  ready,
  save,
  remove,
  failure,
}

@freezed
abstract class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    @Default(HomeStateEnum.initial) HomeStateEnum status,
    @Default([]) List<TorrentRes> favorites,
    @Default(0) int index,
  }) = _HomeState;
}
