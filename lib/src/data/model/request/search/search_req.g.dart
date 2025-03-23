// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchReq _$SearchReqFromJson(Map<String, dynamic> json) => _SearchReq(
  token: json['token'] as String,
  uuid: json['uuid'] as String,
  sort: json['sort'] as String,
  nsfw: json['nsfw'] as String,
  search: json['search'] as String,
  page: (json['page'] as num).toInt(),
);

Map<String, dynamic> _$SearchReqToJson(_SearchReq instance) =>
    <String, dynamic>{
      'token': instance.token,
      'uuid': instance.uuid,
      'sort': instance.sort,
      'nsfw': instance.nsfw,
      'search': instance.search,
      'page': instance.page,
    };
