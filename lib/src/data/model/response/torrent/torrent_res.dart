// ignore_for_file: depend_on_referenced_packages

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/app_constant.dart';

part 'torrent_res.freezed.dart';
part 'torrent_res.g.dart';

@freezed
abstract class TorrentRes with _$TorrentRes {
  const TorrentRes._();

  const factory TorrentRes({
    @Default("") String magnet,
    @Default("") String age,
    @Default("") String name,
    @Default("") String size,
    @Default(0) int seeder,
    @Default(0) int leecher,
    @Default(TorrentType.all)
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: TorrentType.fromJson, toJson: TorrentType.toJson)
    TorrentType type,
    @Default("") String site,
    @Default("") String url,
    @Default(false) bool trusted,
    @Default(false) bool nsfw,
  }) = _Torrent;

  factory TorrentRes.fromJson(Map<String, Object?> json) =>
      _$TorrentResFromJson(json);
}
