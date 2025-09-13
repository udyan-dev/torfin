import 'dart:async';
import '../../../../core/bindings/di.dart';
import '../engine.dart';
import '../file.dart';
import '../torrent.dart';

final _slashRegex = RegExp('/');
int countSlashesRegex(String text) => _slashRegex.allMatches(text).length;

String truncateFromLastSlash(String text) {
  final i = text.lastIndexOf('/');
  return i == -1 ? text : text.substring(i + 1);
}

List<File> getExternalSubtitles(File file, Torrent torrent) {
  final slashesCount = countSlashesRegex(file.name);
  return torrent.files
      .where((f) => slashesCount == countSlashesRegex(f.name) && f.name.endsWith('.srt'))
      .toList();
}

Future<void> downloadSubtitles(File file, Torrent torrent) async {
  final List<File> subtitles = getExternalSubtitles(file, torrent);
  for (final sub in subtitles) {
    await torrent.setSequentialDownloadFromPiece(sub.piecesRange.first);
    await _waitForFileComplete(torrent: torrent, fileName: sub.name);
  }
}

Future<void> _waitForFileComplete({
  required Torrent torrent,
  required String fileName,
}) async {
  final completer = Completer<void>();
  final file = torrent.files.firstWhere((f) => f.name == fileName);

  Future<void> testFileComplete(Timer? timer) async {
    final t = await di<Engine>().fetchTorrent(torrent.id);
    var isDownloaded = true;
    for (var i = file.piecesRange.first; i < file.piecesRange.last; i++) {
      if (t.pieces[i] != true) {
        isDownloaded = false;
        break;
      }
    }
    if (isDownloaded) {
      timer?.cancel();
      if (!completer.isCompleted) completer.complete();
    }
  }

  Timer.periodic(const Duration(seconds: 1), testFileComplete);
  await testFileComplete(null);
  return completer.future;
}

class ExternalSubtitle {
  final String url;
  final String name;

  ExternalSubtitle({required this.url, required this.name});
}
