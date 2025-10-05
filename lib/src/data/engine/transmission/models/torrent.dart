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
    : wanted = json['wanted'],
      piecesRange = List<int>.from(json['piecesRange']);
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
    : id = json['id'] as int,
      name = json['name'] as String,
      percentDone = json['percentDone'] is int
          ? (json['percentDone'] as int).toDouble()
          : json['percentDone'] as double,
      status = TorrentStatus.values[json['status'] as int],
      totalSize = json['totalSize'] as int,
      rateDownload = json['rateDownload'] as int,
      rateUpload = json['rateUpload'] as int,
      downloadedEver = json['downloadedEver'] as int,
      uploadedEver = json['uploadedEver'] as int,
      eta = json['eta'] as int,
      pieces = convertBitfieldToBoolList(
        base64Decode(json['pieces'] as String),
        json['pieceCount'] as int,
      ),
      pieceCount = json['pieceCount'] as int,
      pieceSize = json['pieceSize'] as int,
      errorString = json['errorString'] as String,
      location = json['downloadDir'] as String,
      isPrivate = json['isPrivate'] as bool,
      addedDate = json['addedDate'] as int,
      creator = json['creator'] as String,
      comment = json['comment'] as String,
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
      labels = List<String>.from(json['labels'] as List),
      peersConnected = json['peersConnected'] as int,
      magnetLink = json['magnetLink'] as String,
      sequentialDownload = json['sequentialDownload'] as bool,
      doneDate = DateTime.fromMillisecondsSinceEpoch(
        (json['doneDate'] as int) * 1000,
      );
}
