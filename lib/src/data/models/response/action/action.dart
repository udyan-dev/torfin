import 'package:freezed_annotation/freezed_annotation.dart';

part 'action.freezed.dart';

part 'action.g.dart';

@freezed
abstract class ActionModel with _$ActionModel {
  const factory ActionModel({
    @Default("") String actionTitle,
    @Default([]) List<ActionItem> actionItems,
  }) = _ActionModel;

  const ActionModel._();

  factory ActionModel.fromJson(Map<String, Object?> json) =>
      _$ActionModelFromJson(json);
}

@freezed
abstract class ActionItem with _$ActionItem {
  const factory ActionItem({
    @Default("") String title,
    @Default("") String value,
    @Default(false) bool isSelected,
  }) = _ActionItem;

  const ActionItem._();

  factory ActionItem.fromJson(Map<String, Object?> json) =>
      _$ActionItemFromJson(json);
}
