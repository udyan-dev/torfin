import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'models/torrents_resume_status.dart';
import 'session.dart';
import 'torrent.dart';
import 'transmission/models/torrent_set_location.dart';

enum TorrentAddedResponse { added, duplicated }

class TorrentAddError extends Error {}

Future<String> getTorrentsStatusFilePath() async {
  return path.join(
    (await getApplicationSupportDirectory()).path,
    'torrents_resume_status.json',
  );
}

abstract class Engine {
  Future init();
  Future dispose();
  Future<TorrentAddedResponse> addTorrent(
    String? filename,
    String? metainfo,
    String? downloadDir,
  );
  Future<List<Torrent>> fetchTorrents();
  Future<Torrent> fetchTorrent(int id);
  Future<Session> fetchSession();
  Future resetSettings();

  Future saveTorrentsResumeStatus() async {
    final torrents = await fetchTorrents();
    final filePath = await getTorrentsStatusFilePath();
    final file = File(filePath);
    final torrentResumeStatus = TorrentsResumeStatus.fromTorrents(torrents);
    await file.writeAsString(jsonEncode(torrentResumeStatus.toJson()));
  }

  Future setTorrentsLocation(
    TorrentSetLocationArguments torrentSetLocationArguments,
  );

  Future restoreTorrentsResumeStatus() async {
    try {
      final filePath = await getTorrentsStatusFilePath();
      final file = File(filePath);
      final jsonString = await File(filePath).readAsString();
      final torrentResumeStatus = TorrentsResumeStatus.fromJson(
        jsonDecode(jsonString),
      );

      final torrents = await fetchTorrents();
      for (final torrentResumeStatus in torrentResumeStatus.torrents) {
        final torrentInstance = torrents.firstWhere(
          (t) => t.name == torrentResumeStatus.name,
        );

        if (torrentResumeStatus.status == TorrentResumeState.started) {
          torrentInstance.start();
        }

        if (torrentInstance.sequentialDownload) {
          torrentInstance.setSequentialDownloadFromPiece(0);
          torrentInstance.setSequentialDownload(false);
        }

        for (final (index, fileResumeStatus)
            in torrentResumeStatus.files.indexed) {
          if (fileResumeStatus &&
              torrentInstance.files[index].wanted == false) {
            torrentInstance.toggleFileWanted(index, true);
          }
        }
      }

      await file.delete();
    } catch (_) {}
  }
}
