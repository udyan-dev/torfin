// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'torrent_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Torrent _$TorrentFromJson(Map<String, dynamic> json) => _Torrent(
  magnet: json['magnet'] as String? ?? '',
  age: json['age'] as String? ?? '',
  name: json['name'] as String? ?? '',
  size: json['size'] as String? ?? '',
  seeder: (json['seeder'] as num?)?.toInt() ?? 0,
  leecher: (json['leecher'] as num?)?.toInt() ?? 0,
  type: json['type'] as String? ?? '',
  site: json['site'] as String? ?? '',
  url: json['url'] as String? ?? '',
  trusted: json['trusted'] as bool? ?? false,
  nsfw: json['nsfw'] as bool? ?? false,
);

Map<String, dynamic> _$TorrentToJson(_Torrent instance) => <String, dynamic>{
  'magnet': instance.magnet,
  'age': instance.age,
  'name': instance.name,
  'size': instance.size,
  'seeder': instance.seeder,
  'leecher': instance.leecher,
  'type': instance.type,
  'site': instance.site,
  'url': instance.url,
  'trusted': instance.trusted,
  'nsfw': instance.nsfw,
};
