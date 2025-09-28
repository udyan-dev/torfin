part of 'settings_cubit.dart';

enum ThemeEnum {
  light("Light", ThemeMode.light),
  system("System", ThemeMode.system),
  dark("Dark", ThemeMode.dark);

  final String title;
  final ThemeMode value;

  const ThemeEnum(this.title, this.value);
}

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool enableSuggestions,
    @Default(false) bool nsfw,
    @Default(false) bool enableSpeedLimits,
    @Default('') String downloadSpeedLimit,
    @Default('') String uploadSpeedLimit,
    @Default('') String downloadQueueSize,
    AppNotification? notification,
  }) = _SettingsState;
}
