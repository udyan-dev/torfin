part of 'splash_cubit.dart';

enum SplashEnum { initial, loading, success, failure }

@freezed
abstract class SplashState with _$SplashState {
  const SplashState._();

  const factory SplashState({@Default(SplashEnum.initial) SplashEnum status}) =
      _SplashState;
}
