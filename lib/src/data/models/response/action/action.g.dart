// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionModel _$ActionModelFromJson(Map<String, dynamic> json) => _ActionModel(
  actionTitle: json['actionTitle'] as String? ?? "",
  actionItems:
      (json['actionItems'] as List<dynamic>?)
          ?.map((e) => ActionItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ActionModelToJson(_ActionModel instance) =>
    <String, dynamic>{
      'actionTitle': instance.actionTitle,
      'actionItems': instance.actionItems,
    };

_ActionItem _$ActionItemFromJson(Map<String, dynamic> json) => _ActionItem(
  title: json['title'] as String? ?? "",
  value: json['value'] as String? ?? "",
  isSelected: json['isSelected'] as bool? ?? false,
);

Map<String, dynamic> _$ActionItemToJson(_ActionItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'isSelected': instance.isSelected,
    };
