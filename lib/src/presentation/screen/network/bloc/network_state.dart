part of 'network_bloc.dart';

enum NetworkEnum { online, offline }

@freezed
class NetworkState with _$NetworkState {
  const factory NetworkState({
    @Default(NetworkEnum.online) NetworkEnum status,
  }) = _Initial;
}
