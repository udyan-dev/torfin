import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:mime/mime.dart';

import '../../../../core/bindings/di.dart';
import '../engine.dart';
import '../file.dart' as torrent_file;
import '../torrent.dart';

class CancellationException implements Exception {}

class StreamingServer {
  late HttpServer _server;
  final Completer<void> _serverReadyCompleter = Completer<void>();

  String filePath;
  final int bufferSize;
  final Torrent torrent;
  final torrent_file.File torrentFile;

  CancelableOperation<void>? _cancelableOperation;

  StreamingServer({
    required this.filePath,
    required this.bufferSize,
    required this.torrent,
    required this.torrentFile,
  });

  void start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _serverReadyCompleter.complete();

    await for (final request in _server) {
      await _cancelableOperation?.cancel();
      final completer = CancelableCompleter<void>();
      _cancelableOperation = CancelableOperation.fromFuture(
        _handleRequest(request, completer),
        onCancel: () => completer.operation.cancel(),
      );
    }
  }

  void stop() async {
    await _cancelableOperation?.cancel();
    await _server.close();
  }

  void cancelRequest() {
    _cancelableOperation?.cancel();
  }

  Future<String> getAddress() async {
    await _serverReadyCompleter.future;
    return 'http://${_server.address.host}:${_server.port}';
  }

  Future<void> _handleRequest(
    HttpRequest request,
    CancelableCompleter<void> cancelableCompleter,
  ) async {
    try {
      if (request.method == 'GET') {
        await _handleGetRequest(request, cancelableCompleter);
      } else {
        request.response.statusCode = HttpStatus.methodNotAllowed;
      }
    } on CancellationException {
      // request canceled
    } catch (_) {
      request.response.statusCode = HttpStatus.internalServerError;
    } finally {
      await request.response.close();
      cancelableCompleter.complete();
    }
  }

  Future<void> _handleGetRequest(
    HttpRequest request,
    CancelableCompleter<void> cancelableCompleter,
  ) async {
    await _waitForPieces(
      from: torrentFile.piecesRange.first,
      count: 1,
      cancelableCompleter: cancelableCompleter,
    );
    final file = File(filePath);
    final fileSize = torrentFile.length;
    final rangeHeader = request.headers.value('range');

    if (rangeHeader != null) {
      await _handleRangeRequest(
        request,
        file,
        fileSize,
        rangeHeader,
        cancelableCompleter,
      );
    } else {
      await _sendFullFile(request, file, fileSize, cancelableCompleter);
    }
  }

  Future<void> _sendFullFile(
    HttpRequest request,
    File file,
    int fileSize,
    CancelableCompleter<void> cancelableCompleter,
  ) async {
    final mimeType = lookupMimeType(filePath) ?? ContentType.binary.mimeType;
    request.response.headers.contentType = ContentType.parse(mimeType);
    request.response.headers.contentLength = fileSize;

    await _pipeFileRangeInBlocks(
      file,
      request.response,
      0,
      fileSize - 1,
      torrent.pieceSize,
      cancelableCompleter,
    );
  }

  Future<void> _handleRangeRequest(
    HttpRequest request,
    File file,
    int fileSize,
    String rangeHeader,
    CancelableCompleter<void> cancelableCompleter,
  ) async {
    final rangeRegex = RegExp(r'bytes=(\d*)-(\d*)');
    final match = rangeRegex.firstMatch(rangeHeader);

    if (match == null) {
      request.response.statusCode = HttpStatus.badRequest;
      return;
    }

    final startStr = match.group(1);
    final endStr = match.group(2);

    var start = 0;
    var end = fileSize - 1;

    if (startStr != null && startStr.isNotEmpty) start = int.parse(startStr);
    if (endStr != null && endStr.isNotEmpty) end = int.parse(endStr);

    if (start < 0 || end >= fileSize || start > end) {
      request.response.statusCode = HttpStatus.requestedRangeNotSatisfiable;
      request.response.headers.set('Content-Range', 'bytes */$fileSize');
      return;
    }

    final contentLength = end - start + 1;

    request.response.statusCode = HttpStatus.partialContent;
    final mimeType = lookupMimeType(filePath) ?? ContentType.binary.mimeType;
    request.response.headers.contentType = ContentType.parse(mimeType);
    request.response.headers.contentLength = contentLength;
    request.response.headers.set(
      'Content-Range',
      'bytes $start-$end/$fileSize',
    );

    final piece = (start / torrent.pieceSize).floor();
    await torrent.setSequentialDownloadFromPiece(piece);
    await _pipeFileRangeInBlocks(
      file,
      request.response,
      start,
      end,
      torrent.pieceSize,
      cancelableCompleter,
    );
  }

  List<int> _computeNeededPieces(int? from, int? count) {
    final List<int> neededPieces = [];
    final neededPiecesCount = count ?? (bufferSize / torrent.pieceSize).ceil();
    final firstPiece = from ?? torrentFile.piecesRange.first;
    final lastPiece = torrentFile.piecesRange.last;
    for (int i = 0; i < neededPiecesCount && firstPiece + i < lastPiece; i++) {
      neededPieces.add(firstPiece + i);
    }

    return neededPieces;
  }

  Future<void> _waitForPieces({
    int? from,
    int? count,
    CancelableCompleter<void>? cancelableCompleter,
  }) async {
    final completer = Completer<void>();
    final neededPieces = _computeNeededPieces(from, count);

    Future<void> testPieces(Timer? timer) async {
      if (cancelableCompleter != null && cancelableCompleter.isCanceled) {
        timer?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(CancellationException());
        }
        return;
      }

      final t = await di<Engine>().fetchTorrent(torrent.id);
      final hasLoaded = t.hasLoadedPieces(neededPieces);

      if (hasLoaded) {
        timer?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    }

    await testPieces(null);

    if (!completer.isCompleted) {
      Timer.periodic(const Duration(seconds: 1), testPieces);
    }

    return completer.future;
  }

  Future<void> _pipeFileRangeInBlocks(
    File file,
    HttpResponse response,
    int start,
    int end,
    int blockSize,
    CancelableCompleter<void> cancelableCompleter,
  ) async {
    var currentStart = start;
    while (currentStart <= end) {
      if (cancelableCompleter.isCanceled) throw CancellationException();

      var currentEnd = currentStart + blockSize - 1;
      if (currentEnd > end) currentEnd = end;

      final piece = (currentStart / torrent.pieceSize).floor();
      await _waitForPieces(
        from: piece,
        cancelableCompleter: cancelableCompleter,
      );

      final readStream = file.openRead(currentStart, currentEnd + 1);
      await for (final chunk in readStream) {
        response.add(chunk);
        await response.flush();
      }

      currentStart = currentEnd + 1;
    }
  }
}
