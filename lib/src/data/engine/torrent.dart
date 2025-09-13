import 'dart:io' show Directory;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';

import '../../../core/bindings/di.dart';
import 'engine.dart';
import 'file.dart';
import 'models/subtitles.dart';

enum TorrentStatus { stopped, queuedToCheck, checking, queuedToDownload, downloading, queuedToSeed, seeding }

class TorrentBase {
  final int id;
  final List<String>? labels;
  const TorrentBase({required this.id, required this.labels});
}

abstract class Torrent extends TorrentBase {
  final String name;
  final double progress;
  final TorrentStatus status;
  final int size;
  final int rateDownload;
  final int rateUpload;
  final int downloadedEver;
  final int uploadedEver;
  final int eta;
  final int pieceCount;
  final List<bool> pieces;
  final int pieceSize;
  final String errorString;
  final String location;
  final bool isPrivate;
  final int addedDate;
  final String creator;
  final String comment;
  final List<File> files;
  final int peersConnected;
  final String magnetLink;
  final bool sequentialDownload;
  final DateTime doneDate;

  const Torrent({
    required super.id,
    required super.labels,
    required this.name,
    required this.progress,
    required this.status,
    required this.size,
    required this.rateDownload,
    required this.rateUpload,
    required this.downloadedEver,
    required this.uploadedEver,
    required this.eta,
    required this.pieces,
    required this.pieceSize,
    required this.errorString,
    required this.pieceCount,
    required this.location,
    required this.isPrivate,
    required this.addedDate,
    required this.comment,
    required this.creator,
    required this.files,
    required this.peersConnected,
    required this.magnetLink,
    required this.sequentialDownload,
    required this.doneDate,
  });

  void start();
  void stop();
  void remove(bool withData);
  Future<void> update(TorrentBase torrent);
  Future<void> toggleFileWanted(int fileIndex, bool wanted);
  Future<void> toggleAllFilesWanted(bool wanted);
  Future<void> setSequentialDownload(bool sequential);
  Future<void> setSequentialDownloadFromPiece(int sequentialDownloadFromPiece);

  Future<void> startStreaming(File file) async {
    if (file.bytesCompleted == file.length) return;
    await di<Engine>().saveTorrentsResumeStatus();
    start();

    final otherTorrents = (await di<Engine>().fetchTorrents()).where((t) => t.id != id);
    for (final otherTorrent in otherTorrents) {
      otherTorrent.stop();
    }

    await toggleAllFilesWanted(false);
    final fileIndex = files.indexWhere((f) => f.name == file.name);
    final externalSubtitles = getExternalSubtitles(file, this);
    for (final f in files) {
      if (externalSubtitles.firstWhereOrNull((s) => s.name == f.name) != null) {
        await toggleFileWanted(fileIndex, true);
      }
    }
    await toggleFileWanted(fileIndex, true);
    await setSequentialDownload(true);
  }

  Future<void> stopStreaming() async {
    setSequentialDownload(false);
    await di<Engine>().restoreTorrentsResumeStatus();
  }

  bool hasLoadedPieces(List<int> piecesToTest) => piecesToTest.every((p) => pieces[p]);

  Future openFolder(BuildContext context) async {
    final folderPath = files.length == 1
        ? location
        : join(location, split(files.first.name).first);

    final result = await OpenFilex.open(folderPath);

    if (result.type != ResultType.done) {
      final errorMessage = switch (result.type) {
        ResultType.noAppToOpen => 'No app to open',
        ResultType.fileNotFound => 'Not found',
        ResultType.permissionDenied => 'Permission denied',
        ResultType.error =>
            await Directory(folderPath).exists() == false ? 'Folder not found' : 'Unknown error',
        _ => 'Unknown error',
      };

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening torrent location: $errorMessage.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}
