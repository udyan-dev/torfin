part of 'connectivity_cubit.dart';

enum ConnectivityEnum { online, offline }

@freezed
abstract class ConnectivityState with _$ConnectivityState {
  const ConnectivityState._();

  const factory ConnectivityState({
    @Default(ConnectivityEnum.online) ConnectivityEnum status,
    @Default(true) bool changed,
  }) = _ConnectivityState;
}
