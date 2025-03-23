// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:torfin/core/helper/base_cubit.dart';
import 'package:torfin/core/utils/app_constant.dart';
import 'package:torfin/src/data/source/local/app_storage.dart';
import 'package:torfin/src/domain/usecase/get_magnet_use_case.dart';

import '../../../../../core/helper/app_exception.dart';
import '../../../../data/model/engine/engine.dart';
import '../../../../data/model/engine/session.dart';
import '../../../../data/model/engine/torrent.dart';
import '../../../../data/model/response/torrent/torrent_res.dart';

part 'download_cubit.freezed.dart';
part 'download_state.dart';

// Reduced to 1 second for more responsive updates while preventing excessive API calls
const refreshIntervalMs = 1000;

enum Sort { addedDate, progress, size }

class Filters {
  Set<String> labels = {};

  Filters({required this.labels});

  bool get enabled => labels.isNotEmpty;

  Filters.copy(Filters other) : this(labels: Set.from(other.labels));

  void addLabel(String label) => labels.add(label);

  void removeLabel(String label) => labels.remove(label);

  void clear() => labels.clear();
}

class DownloadCubit extends BaseCubit<DownloadState> {
  final AppStorage appStorage;
  final Engine engine;
  final GetMagnetUseCase getMagnetUseCase;
  final CancelToken cancelToken;
  Timer? _refreshTimer;
  Timer? _sessionTimer;

  DownloadCubit({
    required this.appStorage,
    required this.engine,
    required this.getMagnetUseCase,
    required this.cancelToken,
  }) : super(const DownloadState()) {
    _init();
  }

  Future<void> _init() async {
    await loadSettings();
    await fetchTorrents();
    startAutoRefresh();
  }

  @override
  Future<void> closeToken() async {
    stopAutoRefresh();
    _refreshTimer?.cancel();
    _sessionTimer?.cancel();
  }

  Future<void> loadSettings() async {
    try {
      var sortName = await appStorage.getCommon('sort') ?? state.sort.name;
      var sort = Sort.values.firstWhere(
        (e) => e.name == sortName,
        orElse: () => state.sort,
      );
      var reverseSort =
          await appStorage.getCommon('reverseSort') ?? state.reverseSort;

      emit(
        state.copyWith(
          sort: sort,
          reverseSort: reverseSort,
          filters: Filters(labels: {}),
          status: DownloadStateEnum.ready,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DownloadStateEnum.failure,
          error: AppExceptionType.unknown,
        ),
      );
    }
  }

  List<Torrent> _applyFilters(List<Torrent> torrents) {
    // First apply text filtering if any
    var filteredTorrents =
        state.filterText.isNotEmpty
            ? extractAllSorted(
              query: state.filterText,
              choices: torrents,
              getter: (t) => t.name,
              cutoff: 60,
            ).map((result) => torrents[result.index]).toList()
            : torrents;

    // Then apply label filtering if any
    if (state.filters?.enabled == true) {
      filteredTorrents =
          filteredTorrents
              .where(
                (t) => state.filters!.labels.every(
                  (label) => t.labels?.contains(label) == true,
                ),
              )
              .toList();
    }

    return filteredTorrents;
  }

  List<Torrent> _sortTorrents(List<Torrent> torrents) {
    if (torrents.isEmpty) return torrents;

    // Create a copy to avoid modifying the original list
    var sortedTorrents = List<Torrent>.from(torrents);

    switch (state.sort) {
      case Sort.addedDate:
        sortedTorrents.sort((a, b) => a.addedDate.compareTo(b.addedDate));
        break;
      case Sort.progress:
        sortedTorrents.sort((a, b) => a.progress.compareTo(b.progress));
        break;
      case Sort.size:
        sortedTorrents.sort((a, b) => a.size.compareTo(b.size));
        break;
    }

    return state.reverseSort
        ? sortedTorrents.reversed.toList()
        : sortedTorrents;
  }

  Future<void> fetchTorrents() async {
    try {
      // Use optimistic updates - don't set to reset state unless necessary
      if (state.torrents.isEmpty) {
        emit(state.copyWith(status: DownloadStateEnum.reset));
      }

      final torrents = await engine.fetchTorrents();

      // Extract all unique labels from torrents
      final labels =
          torrents
              .fold<Set<String>>(
                {},
                (labels, torrent) => labels..addAll(torrent.labels ?? []),
              )
              .toList();

      // Remove filtered labels that don't exist anymore
      final currentFilters = state.filters ?? Filters(labels: {});
      final updatedFilters = Filters.copy(currentFilters);
      updatedFilters.labels.removeWhere((label) => !labels.contains(label));

      emit(
        state.copyWith(
          torrents: torrents,
          labels: labels,
          filters: updatedFilters,
          hasLoaded: true,
        ),
      );

      processDisplayedTorrents();
    } catch (e) {
      emit(
        state.copyWith(
          status: DownloadStateEnum.failure,
          error: AppExceptionType.unknown,
        ),
      );
    }
  }

  Future<void> fetchSession() async {
    try {
      final session = await engine.fetchSession();

      // Only update if session data has changed
      if (state.session != session) {
        emit(state.copyWith(session: session));
      }
    } catch (e) {
      // Only emit failure if not already in failure state
      if (state.status != DownloadStateEnum.failure) {
        emit(
          state.copyWith(
            status: DownloadStateEnum.failure,
            error: AppExceptionType.unknown,
          ),
        );
      }
    }
  }

  void processDisplayedTorrents() {
    final sortedTorrents = _sortTorrents(state.torrents);
    final displayedTorrents = _applyFilters(sortedTorrents);

    emit(
      state.copyWith(
        displayedTorrents: displayedTorrents,
        status: DownloadStateEnum.ready,
      ),
    );
  }

  void setFilterText(String value) {
    if (state.filterText == value) return; // Avoid unnecessary updates
    emit(state.copyWith(filterText: value));
    processDisplayedTorrents();
  }

  Future<void> setSort(Sort value, bool reverse) async {
    // Avoid unnecessary updates and storage operations
    if (state.sort == value && state.reverseSort == reverse) return;

    await appStorage.setCommon('sort', value.name);
    await appStorage.setCommon('reverseSort', reverse);

    emit(state.copyWith(sort: value, reverseSort: reverse));
    processDisplayedTorrents();
  }

  void setFilters(Filters updatedFilters) {
    // Check if filters actually changed before updating
    if (state.filters?.labels.containsAll(updatedFilters.labels) == true &&
        updatedFilters.labels.containsAll(state.filters?.labels ?? {}) ==
            true) {
      return;
    }

    emit(state.copyWith(filters: updatedFilters));
    processDisplayedTorrents();
  }

  Future<TorrentAddedResponse> addTorrent(TorrentRes torrent) async {
    try {
      emit(state.copyWith(status: DownloadStateEnum.reset));
      final dir = await appStorage.getCommon<String>(AppConstant.storage);
      if (torrent.magnet.isEmpty) {
        final magnet = await getMagnetUseCase.call(
          torrent.url,
          cancelToken: cancelToken,
        );
        if (isSuccess(magnet) && magnet.data?.isNotEmpty == true) {
          final response = await engine.addTorrent(magnet.data?.first, "", dir);
          await fetchTorrents();
          return response;
        } else {
          return TorrentAddedResponse.error;
        }
      } else {
        final response = await engine.addTorrent(torrent.magnet, "", dir);
        await fetchTorrents();
        return response;
      }
    } catch (e) {
      return TorrentAddedResponse.error;
    }
  }

  Future<void> removeTorrent(Torrent torrent, bool withData) async {
    try {
      await torrent.remove(withData);
      await fetchTorrents();
    } catch (e) {
      emit(
        state.copyWith(
          status: DownloadStateEnum.failure,
          error: AppExceptionType.unknown,
        ),
      );
    }
  }

  void startAutoRefresh() {
    // Cancel existing timers if any
    _refreshTimer?.cancel();
    _sessionTimer?.cancel();

    // Set up periodic refresh for torrents
    _refreshTimer = Timer.periodic(
      Duration(milliseconds: refreshIntervalMs),
      (timer) => fetchTorrents(),
    );

    // Set up periodic refresh for session
    _sessionTimer = Timer.periodic(
      Duration(milliseconds: refreshIntervalMs),
      (timer) => fetchSession(),
    );
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _sessionTimer?.cancel();
    _refreshTimer = null;
    _sessionTimer = null;
  }

  void resetFilters() {
    final updatedFilters = Filters(labels: {});
    emit(state.copyWith(filterText: '', filters: updatedFilters));
    processDisplayedTorrents();
  }
}
