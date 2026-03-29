import 'dart:convert';

import '../../../../../core/utils/utils.dart';
import '../../torrent.dart';

enum TorrentField {
  id,
  name,
  status,
  percentDone,
  totalSize,
  rateDownload,
  rateUpload,
  downloadedEver,
  uploadedEver,
  eta,
  pieceCount,
  pieces,
  pieceSize,
  errorString,
  addedDate,
  downloadDir,
  isPrivate,
  creator,
  comment,
  files,
  fileStats,
  labels,
  peersConnected,
  magnetLink,
  sequentialDownload,
  doneDate,
}

class TransmissionTorrentFile {
  final String name;
  final int length;
  final int bytesCompleted;

  const TransmissionTorrentFile(this.name, this.length, this.bytesCompleted);

  TransmissionTorrentFile.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      length = json['length'],
      bytesCompleted = json['bytesCompleted'];
}

class TransmissionTorrentFileStats {
  final bool wanted;
  final List<int> piecesRange;

  const TransmissionTorrentFileStats(this.wanted, this.piecesRange);

  TransmissionTorrentFileStats.fromJson(Map<String, dynamic> json)
    : wanted = json['wanted'] as bool? ?? true,
      piecesRange = List<int>.from(json['piecesRange'] ?? const <int>[]);
}

class TransmissionTorrentModel {
  final int id;
  final String name;
  final double percentDone;
  final TorrentStatus status;
  final int totalSize;
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
  final List<TransmissionTorrentFile> files;
  final List<TransmissionTorrentFileStats> fileStats;
  final List<String> labels;
  final int peersConnected;
  final String magnetLink;
  final bool sequentialDownload;
  final DateTime doneDate;

  const TransmissionTorrentModel(
    this.id,
    this.name,
    this.percentDone,
    this.status,
    this.totalSize,
    this.rateDownload,
    this.rateUpload,
    this.downloadedEver,
    this.uploadedEver,
    this.eta,
    this.errorString,
    this.pieces,
    this.pieceSize,
    this.pieceCount,
    this.addedDate,
    this.isPrivate,
    this.location,
    this.comment,
    this.creator,
    this.files,
    this.labels,
    this.peersConnected,
    this.fileStats,
    this.magnetLink,
    this.sequentialDownload,
    this.doneDate,
  );

  TransmissionTorrentModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int? ?? 0,
      name = json['name'] as String? ?? '',
      percentDone = json['percentDone'] is int
          ? (json['percentDone'] as int).toDouble()
          : (json['percentDone'] as double? ?? 0.0),
      status = (json['status'] is int)
          ? TorrentStatus.values[json['status'] as int]
          : TorrentStatus.stopped,
      totalSize = json['totalSize'] as int? ?? 0,
      rateDownload = json['rateDownload'] as int? ?? 0,
      rateUpload = json['rateUpload'] as int? ?? 0,
      downloadedEver = json['downloadedEver'] as int? ?? 0,
      uploadedEver = json['uploadedEver'] as int? ?? 0,
      eta = json['eta'] as int? ?? 0,
      pieces = (json['pieces'] != null && json['pieceCount'] != null)
          ? convertBitfieldToBoolList(
              base64Decode(json['pieces'] as String),
              json['pieceCount'] as int,
            )
          : List<bool>.filled(json['pieceCount'] as int? ?? 0, false),
      pieceCount = json['pieceCount'] as int? ?? 0,
      pieceSize = json['pieceSize'] as int? ?? 0,
      errorString = json['errorString'] as String? ?? '',
      location = json['downloadDir'] as String? ?? '',
      isPrivate = json['isPrivate'] as bool? ?? false,
      addedDate = json['addedDate'] as int? ?? 0,
      creator = json['creator'] as String? ?? '',
      comment = json['comment'] as String? ?? '',
      files =
          (json['files'] as List?)
              ?.map<TransmissionTorrentFile>(
                (j) =>
                    TransmissionTorrentFile.fromJson(j as Map<String, dynamic>),
              )
              .toList() ??
          const <TransmissionTorrentFile>[],
      fileStats =
          (json['fileStats'] as List?)
              ?.map<TransmissionTorrentFileStats>(
                (j) => TransmissionTorrentFileStats.fromJson(
                  j as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const <TransmissionTorrentFileStats>[],
      labels = List<String>.from(json['labels'] ?? const <String>[]),
      peersConnected = json['peersConnected'] as int? ?? 0,
      magnetLink = json['magnetLink'] as String? ?? '',
      sequentialDownload = json['sequentialDownload'] as bool? ?? false,
      doneDate = DateTime.fromMillisecondsSinceEpoch(
        ((json['doneDate'] as int?) ?? 0) * 1000,
      );
}
