import '../../data/models/response/torrent/torrent_res.dart';
import '../widgets/selection_notifier.dart';

class SelectionHelper {
  static Set<String> getKeysFromTorrents(List<TorrentRes> torrents) =>
      torrents.map((t) => t.identityKey).toSet();

  static bool? getSelectAllValue(SelectionNotifier selection, int totalCount) {
    if (totalCount == 0) return false;
    final selectedCount = selection.count;
    if (selectedCount == 0) return false;
    if (selectedCount == totalCount) return true;
    return null;
  }
}
