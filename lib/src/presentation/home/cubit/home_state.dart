part of 'home_cubit.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(DataStatus.initial) DataStatus status,
    @Default(EmptyState()) EmptyState emptyState,
    AppNotification? notification,
    String? intentUri,
  }) = _HomeState;
}
