import 'package:freezed_annotation/freezed_annotation.dart';

part 'empty_state.freezed.dart';
part 'empty_state.g.dart';

@freezed
abstract class EmptyState with _$EmptyState {
  const factory EmptyState({
    @Default('') String stateIcon,
    @Default('') String title,
    @Default('') String description,
    @Default('') String buttonText,
  }) = _EmptyState;

  const EmptyState._();

  factory EmptyState.fromJson(Map<String, Object?> json) =>
      _$EmptyStateFromJson(json);
}
