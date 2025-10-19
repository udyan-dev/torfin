part of 'download_cubit.dart';

enum DownloadStatus { initial, success, error }

enum TorrentDownloadStatus {
  all(allTitle),
  downloading(downloadingTitle),
  completed(completedTitle),
  queued(queuedTitle),
  stopped(stoppedTitle);

  final String title;

  const TorrentDownloadStatus(this.title);
}

@freezed
sealed class DownloadState with _$DownloadState {
  const factory DownloadState({
    @Default(DownloadStatus.initial) DownloadStatus status,
    @Default(<Torrent>[]) List<Torrent> torrents,
    Session? session,
    String? selectedCategoryRaw,
    @Default(false) bool isBulkOperationInProgress,
  }) = _DownloadState;
}
