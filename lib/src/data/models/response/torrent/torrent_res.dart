import 'package:freezed_annotation/freezed_annotation.dart';

part 'torrent_res.freezed.dart';
part 'torrent_res.g.dart';

@freezed
abstract class TorrentRes with _$TorrentRes {
  const factory TorrentRes({
    @Default('') String magnet,
    @Default('') String age,
    @Default('') String name,
    @Default('') String size,
    @Default(0) int seeder,
    @Default(0) int leecher,
    @Default('') String type,
    @Default('') String site,
    @Default('') String url,
    @Default(false) bool trusted,
    @Default(false) bool nsfw,
  }) = _Torrent;

  const TorrentRes._();

  factory TorrentRes.fromJson(Map<String, Object?> json) =>
      _$TorrentResFromJson(json);
}

extension TorrentIdentity on TorrentRes {
  String get identityKey {
    if (magnet.isNotEmpty) return 'm:$magnet';
    if (url.isNotEmpty) return 'u:$url';
    return 'n:$name|$size';
  }
}

enum SortType {
  none('Relevance', 'NONE'),
  age('Recent', 'DATE'),
  seeds('Seeds', 'SEED'),
  leeches('Leeches', 'LEECH'),
  sizeAsc('Size Ascending', 'SIZE_ASC'),
  sizeDsc('Size Descending', 'SIZE');

  const SortType(this.title, this.value);

  final String title;
  final String value;
}
