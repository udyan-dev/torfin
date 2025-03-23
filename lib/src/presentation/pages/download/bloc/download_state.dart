part of 'download_cubit.dart';

enum DownloadStateEnum { initial, ready, reset, failure }

@freezed
abstract class DownloadState with _$DownloadState {
  const DownloadState._();

  const factory DownloadState({
    @Default(DownloadStateEnum.initial) DownloadStateEnum status,
    @Default(AppExceptionType.unknown) AppExceptionType error,
    Session? session,
    @Default([]) List<Torrent> torrents,
    @Default([]) List<Torrent> displayedTorrents,
    @Default([]) List<String> labels,
    @Default('') String filterText,
    @Default(false) bool hasLoaded,
    @Default(Sort.addedDate) Sort sort,
    @Default(true) bool reverseSort,
    Filters? filters,
  }) = _DownloadState;

  // Add helper methods for state comparison
  bool get isLoading =>
      status == DownloadStateEnum.initial || status == DownloadStateEnum.reset;
  bool get hasError => status == DownloadStateEnum.failure;
  bool get isFiltered => filterText.isNotEmpty || (filters?.enabled == true);
  int get totalTorrents => torrents.length;
  int get filteredTorrentsCount => displayedTorrents.length;
}
