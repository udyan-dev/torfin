// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empty_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmptyState _$EmptyStateFromJson(Map<String, dynamic> json) => _EmptyState(
  stateIcon: json['stateIcon'] as String? ?? '',
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  buttonText: json['buttonText'] as String? ?? '',
);

Map<String, dynamic> _$EmptyStateToJson(_EmptyState instance) =>
    <String, dynamic>{
      'stateIcon': instance.stateIcon,
      'title': instance.title,
      'description': instance.description,
      'buttonText': instance.buttonText,
    };
