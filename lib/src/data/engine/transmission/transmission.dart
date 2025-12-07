import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_torrent/flutter_torrent.dart' as flutter_torrent;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../core/utils/utils.dart' as android;
import '../engine.dart';
import '../file.dart' as torrent_file;
import '../session.dart';
import '../torrent.dart';
import 'models/session_get_request.dart';
import 'models/session_get_response.dart';
import 'models/session_set_request.dart';
import 'models/torrent.dart';
import 'models/torrent_action_request.dart';
import 'models/torrent_add_request.dart';
import 'models/torrent_add_response.dart';
import 'models/torrent_get_request.dart';
import 'models/torrent_get_response.dart';
import 'models/torrent_remove_request.dart';
import 'models/torrent_set_location.dart';
import 'models/torrent_set_request.dart';

Future<Directory> getConfigDir() async {
  final configDir = path.join(
    (await getApplicationSupportDirectory()).path,
    'transmission',
  );
  return Directory(configDir);
}

const torrentGetFields = [
  TorrentField.id,
  TorrentField.name,
  TorrentField.percentDone,
  TorrentField.status,
  TorrentField.totalSize,
  TorrentField.rateDownload,
  TorrentField.rateUpload,
  TorrentField.labels,
  TorrentField.addedDate,
  TorrentField.errorString,
  TorrentField.isPrivate,
  TorrentField.downloadDir,
  TorrentField.files,
  TorrentField.fileStats,
  TorrentField.downloadedEver,
  TorrentField.uploadedEver,
  TorrentField.eta,
  TorrentField.pieces,
  TorrentField.pieceSize,
  TorrentField.pieceCount,
  TorrentField.comment,
  TorrentField.creator,
  TorrentField.peersConnected,
  TorrentField.magnetLink,
  TorrentField.sequentialDownload,
  TorrentField.doneDate,
];

TransmissionTorrent createTransmissionTorrentFromJson(
  TransmissionTorrentModel torrent,
) {
  return TransmissionTorrent(
    id: torrent.id,
    name: torrent.name,
    progress: torrent.percentDone,
    status: torrent.status,
    size: torrent.totalSize,
    rateDownload: torrent.rateDownload,
    rateUpload: torrent.rateUpload,
    labels: torrent.labels,
    addedDate: torrent.addedDate,
    errorString: torrent.errorString,
    magnetLink: torrent.magnetLink,
    isPrivate: torrent.isPrivate,
    location: torrent.location,
    files: torrent.files.asMap().entries.map((entry) {
      final stats = entry.key < torrent.fileStats.length
          ? torrent.fileStats[entry.key]
          : null;
      return torrent_file.File(
        name: entry.value.name,
        length: entry.value.length,
        bytesCompleted: entry.value.bytesCompleted,
        wanted: stats?.wanted ?? true,
        piecesRange: stats?.piecesRange ?? const [],
      );
    }).toList(),
    downloadedEver: torrent.downloadedEver,
    uploadedEver: torrent.uploadedEver,
    eta: torrent.eta,
    pieces: torrent.pieces,
    pieceCount: torrent.pieceCount,
    pieceSize: torrent.pieceSize,
    comment: torrent.comment,
    creator: torrent.creator,
    peersConnected: torrent.peersConnected,
    sequentialDownload: torrent.sequentialDownload,
    doneDate: torrent.doneDate,
  );
}

class TransmissionTorrent extends Torrent {
  TransmissionTorrent({
    required super.id,
    required super.name,
    required super.progress,
    required super.status,
    required super.size,
    required super.rateDownload,
    required super.rateUpload,
    required super.downloadedEver,
    required super.uploadedEver,
    required super.eta,
    required super.pieces,
    required super.pieceCount,
    required super.pieceSize,
    required super.errorString,
    required super.addedDate,
    required super.isPrivate,
    required super.location,
    required super.creator,
    required super.comment,
    required super.files,
    required super.labels,
    required super.peersConnected,
    required super.magnetLink,
    required super.sequentialDownload,
    required super.doneDate,
  });

  @override
  start() {
    final request = TorrentActionRequest(
      action: TorrentAction.start,
      arguments: TorrentActionRequestArguments(ids: [id]),
    );
    flutter_torrent.requestAsync(jsonEncode(request));
  }

  @override
  stop() {
    final request = TorrentActionRequest(
      action: TorrentAction.stop,
      arguments: TorrentActionRequestArguments(ids: [id]),
    );
    flutter_torrent.requestAsync(jsonEncode(request));
  }

  @override
  Future<void> remove(bool withData) async {
    final request = TorrentRemoveRequest(
      arguments: TorrentRemoveRequestArguments(
        ids: [id],
        deleteLocalData: withData,
      ),
    );
    await flutter_torrent.requestAsync(jsonEncode(request));
  }

  @override
  Future update(TorrentBase torrent) async {
    final request = TorrentSetRequest(
      arguments: TorrentSetRequestArguments(ids: [id], labels: torrent.labels),
    );
    await flutter_torrent.requestAsync(jsonEncode(request));
  }

  @override
  Future toggleFileWanted(int fileIndex, bool wanted) async {
    final request = TorrentSetRequest(
      arguments: TorrentSetRequestArguments(
        ids: [id],
        filesWanted: wanted ? [fileIndex] : null,
        filesUnwanted: !wanted ? [fileIndex] : null,
      ),
    );
    await flutter_torrent.requestAsync(jsonEncode(request));
  }

  @override
  Future toggleAllFilesWanted(bool wanted) async {
    final filesIndexesNotCompleted = files.indexed
        .where(
          (indexedElement) =>
              indexedElement.$2.bytesCompleted != indexedElement.$2.length,
        )
        .map((indexedElement) => indexedElement.$1)
        .toList();

    final request = TorrentSetRequest(
      arguments: wanted
          ? TorrentSetRequestArguments(
              ids: [id],
              filesWanted: filesIndexesNotCompleted,
            )
          : TorrentSetRequestArguments(
              ids: [id],
              filesUnwanted: filesIndexesNotCompleted,
            ),
    );
    await flutter_torrent.requestAsync(jsonEncode(request));
  }

  @override
  Future setSequentialDownload(bool sequential) async {
    final request = TorrentSetRequest(
      arguments: TorrentSetRequestArguments(
        ids: [id],
        sequentialDownload: sequential,
      ),
    );

    await flutter_torrent.requestAsync(jsonEncode(request));
  }

  @override
  Future setSequentialDownloadFromPiece(int piece) async {
    final request = TorrentSetRequest(
      arguments: TorrentSetRequestArguments(
        ids: [id],
        sequentialDownloadFromPiece: piece,
      ),
    );

    await flutter_torrent.requestAsync(jsonEncode(request));
  }
}

class TransmissionSession extends Session {
  TransmissionSession({
    super.downloadDir,
    super.downloadQueueEnabled,
    super.downloadQueueSize,
    super.peerPort,
    super.speedLimitDownEnabled,
    super.speedLimitUpEnabled,
    super.speedLimitDown,
    super.speedLimitUp,
  });

  @override
  Future<void> update(SessionBase session) async {
    final SessionSetRequest request = SessionSetRequest(
      arguments: SessionSetRequestArguments(
        downloadDir: session.downloadDir,
        downloadQueueSize: session.downloadQueueSize,
        peerPort: session.peerPort,
        speedLimitDownEnabled: session.speedLimitDownEnabled,
        speedLimitUpEnabled: session.speedLimitUpEnabled,
        speedLimitDown: session.speedLimitDown,
        speedLimitUp: session.speedLimitUp,
      ),
    );

    await flutter_torrent.requestAsync(jsonEncode(request));
    flutter_torrent.saveSettings();
  }
}

class TransmissionEngine extends Engine {
  @override
  init() async {
    final serviceRunning =
        Platform.isAndroid && await FlutterForegroundTask.isRunningService;
    if (!serviceRunning) {
      final configDir = await getConfigDir();
      flutter_torrent.initSession(configDir.path, 'transmission');
    }
    if (Platform.isAndroid) {
      await android.initDefaultDownloadDir(this);
    }
  }

  @override
  Future dispose() {
    return Isolate.run(() => flutter_torrent.closeSession());
  }

  @override
  Future<TorrentAddedResponse> addTorrent(
    String? filename,
    String? metainfo,
    String? downloadDir,
  ) async {
    final torrentAddRequest = TorrentAddRequest(
      arguments: TorrentAddRequestArguments(
        filename: filename,
        metainfo: metainfo,
        downloadDir: downloadDir,
      ),
    );
    final jsonResponse = await flutter_torrent.requestAsync(
      jsonEncode(torrentAddRequest),
    );
    final TorrentAddResponse response = TorrentAddResponse.fromJson(
      jsonDecode(jsonResponse),
    );

    if (response.result != 'success') {
      throw TorrentAddError();
    }

    if (response.arguments.torrentDuplicate) {
      return TorrentAddedResponse.duplicated;
    }

    return TorrentAddedResponse.added;
  }

  @override
  Future<List<Torrent>> fetchTorrents() async {
    final String res = await flutter_torrent.requestAsync(
      jsonEncode(
        TorrentGetRequest(
          arguments: TorrentGetRequestArguments(fields: torrentGetFields),
        ),
      ),
    );

    final TorrentGetResponse decodedRes = TorrentGetResponse.fromJson(
      jsonDecode(res),
    );

    return decodedRes.arguments.torrents
        .map((torrent) => createTransmissionTorrentFromJson(torrent))
        .toList();
  }

  @override
  Future<Torrent> fetchTorrent(int id) async {
    final String res = await flutter_torrent.requestAsync(
      jsonEncode(
        TorrentGetRequest(
          arguments: TorrentGetRequestArguments(
            ids: [id],
            fields: torrentGetFields,
          ),
        ),
      ),
    );

    final TorrentGetResponse decodedRes = TorrentGetResponse.fromJson(
      jsonDecode(res),
    );

    if (decodedRes.arguments.torrents.isEmpty) {
      throw StateError('Torrent with id $id not found');
    }

    return createTransmissionTorrentFromJson(
      decodedRes.arguments.torrents.first,
    );
  }

  @override
  Future<Session> fetchSession() async {
    final SessionGetRequest sessionGetRequest = SessionGetRequest(
      arguments: SessionGetRequestArguments(
        fields: [
          SessionField.downloadDir,
          SessionField.downloadQueueEnabled,
          SessionField.downloadQueueSize,
          SessionField.peerPort,
          SessionField.speedLimitDownEnabled,
          SessionField.speedLimitUpEnabled,
          SessionField.speedLimitDown,
          SessionField.speedLimitUp,
        ],
      ),
    );
    final String res = await flutter_torrent.requestAsync(
      jsonEncode(sessionGetRequest),
    );

    final SessionGetResponse decodedRes = SessionGetResponse.fromJson(
      jsonDecode(res),
    );

    return TransmissionSession(
      downloadDir: decodedRes.arguments.downloadDir,
      downloadQueueEnabled: decodedRes.arguments.downloadQueueEnabled,
      downloadQueueSize: decodedRes.arguments.downloadQueueSize,
      peerPort: decodedRes.arguments.peerPort,
      speedLimitDownEnabled: decodedRes.arguments.speedLimitDownEnabled,
      speedLimitUpEnabled: decodedRes.arguments.speedLimitUpEnabled,
      speedLimitDown: decodedRes.arguments.speedLimitDown,
      speedLimitUp: decodedRes.arguments.speedLimitUp,
    );
  }

  @override
  Future resetSettings() async {
    flutter_torrent.resetSettings();
    if (Platform.isAndroid) {
      await android.initDefaultDownloadDir(this);
    }
  }

  @override
  Future setTorrentsLocation(
    TorrentSetLocationArguments torrentSetLocationArguments,
  ) async {
    final request = TorrentSetLocationRequest(
      arguments: torrentSetLocationArguments,
    );
    await flutter_torrent.requestAsync(jsonEncode(request));
  }
}
