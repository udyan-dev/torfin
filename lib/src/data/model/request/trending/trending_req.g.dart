// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrendingReq _$TrendingReqFromJson(Map<String, dynamic> json) => _TrendingReq(
  token: json['token'] as String,
  uuid: json['uuid'] as String,
  sort: json['sort'] as String,
  top: json['top'] as String,
  nsfw: json['nsfw'] as String,
);

Map<String, dynamic> _$TrendingReqToJson(_TrendingReq instance) =>
    <String, dynamic>{
      'token': instance.token,
      'uuid': instance.uuid,
      'sort': instance.sort,
      'top': instance.top,
      'nsfw': instance.nsfw,
    };
