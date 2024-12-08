part of 'splash_bloc.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState({
    @Default(DataEnum.initial) DataEnum status,
  }) = _SplashState;
}
