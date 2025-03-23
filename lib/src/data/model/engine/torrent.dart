// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import '../../../injection.dart';
import 'engine.dart';
import 'file.dart';
import 'package:path/path.dart';

import '../../../../core/utils/device.dart';

// Torrent statuses
enum TorrentStatus {
  stopped,
  queuedToCheck,
  checking,
  queuedToDownload,
  downloading,
  queuedToSeed,
  seeding,
}

class TorrentBase {
  final int id;
  final List<String>? labels;

  TorrentBase({required this.id, required this.labels});
}

// Torrent abstraction
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

  Torrent({
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
  });

  // Start the torrent
  start();

  // Pause the torrent
  stop();

  // Remove the torrent
  remove(bool withData);

  // Update torrent data
  Future update(TorrentBase torrent);

  Future toggleFileWanted(int fileIndex, bool wanted);

  Future toggleAllFilesWanted(bool wanted);

  Future setSequentialDownload(bool sequential);

  Future setSequentialDownloadFromPiece(int sequentialDownloadFromPiece);

  startStreaming(File file) async {
    debugPrint('starting streaming ${file.name}');
    // File already completed
    if (file.bytesCompleted == file.length) {
      // Do nothing if file is already completed.
      return;
    }

    await di<Engine>().saveTorrentsResumeStatus();

    // Be sure torrent is active
    start();

    final otherTorrents = (await di<Engine>().fetchTorrents()).where(
      (t) => t.id != id,
    );

    // Pause all other torrents
    for (final otherTorrent in otherTorrents) {
      otherTorrent.stop();
    }

    await toggleAllFilesWanted(false);
    final fileIndex = files.indexWhere((f) => f.name == file.name);
    await toggleFileWanted(fileIndex, true);
    await setSequentialDownload(true);
  }

  stopStreaming() async {
    debugPrint('stopping streaming');
    setSequentialDownload(false);
    await di<Engine>().restoreTorrentsResumeStatus();
  }

  hasLoadedPieces(List<int> piecesToTest) {
    return piecesToTest.every((p) => pieces[p]);
  }

  Future openFolder(BuildContext context) async {
    if (!isDesktop()) return;

    String folderPath;

    if (files.length == 1) {
      folderPath = location;
    } else {
      var folderName = split(files.first.name).first;
      folderPath = join(location, folderName);
    }

    // Use OpenFilex to open the folder or file
    final result = await OpenFilex.open(folderPath);

    // Handle the result
    if (result.type != ResultType.done) {
      String errorMessage;

      switch (result.type) {
        case ResultType.noAppToOpen:
          errorMessage = 'No app to open';
          break;
        case ResultType.fileNotFound:
          errorMessage = 'Folder or file not found';
          break;
        case ResultType.permissionDenied:
          errorMessage = 'Permission denied';
          break;
        case ResultType.error:
          errorMessage =
              await Directory(folderPath).exists() == false
                  ? 'Folder not found'
                  : 'Unknown error';
          break;
        default:
          errorMessage = 'Unknown error';
      }

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
