import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/helpers/data_state.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/engine/engine.dart';
import '../../../data/engine/session.dart';
import '../../../data/engine/torrent.dart';
import '../../../domain/usecases/add_torrent_use_case.dart';

part 'download_cubit.freezed.dart';
part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final Engine _engine;
  final AddTorrentUseCase _addTorrentUseCase;
  Timer? _refreshTimer;

  List<Torrent> _allTorrents = const <Torrent>[];
  TorrentDownloadStatus _filterStatus = TorrentDownloadStatus.all;

  DownloadCubit({
    required Engine engine,
    required AddTorrentUseCase addTorrentUseCase,
  }) : _engine = engine,
       _addTorrentUseCase = addTorrentUseCase,
       super(const DownloadState());

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    try {
      final (session, torrents) = await Future.wait([
        _engine.fetchSession(),
        _engine.fetchTorrents(),
      ]).then((r) => (r[0] as Session?, r[1] as List<Torrent>));
      _allTorrents = torrents;
      emit(
        state.copyWith(
          status: DownloadStatus.success,
          session: session,
          torrents: _filterByStatus(_allTorrents, _filterStatus),
          selectedCategoryRaw: _filterStatus.title,
        ),
      );
      startAutoRefresh();
    } catch (_) {
      emit(state.copyWith(status: DownloadStatus.error));
    }
  }

  void startAutoRefresh({
    Duration interval = const Duration(milliseconds: 250),
  }) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(interval, (_) async {
      try {
        final torrents = await _engine.fetchTorrents();
        _allTorrents = torrents;
        emit(
          state.copyWith(
            torrents: _filterByStatus(_allTorrents, _filterStatus),
          ),
        );
      } catch (_) {}
    });
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<TorrentAddedResponse?> addTorrent(
    String magnetLink, {
    String? downloadDir,
  }) async {
    final response = await _addTorrentUseCase.call(
      AddTorrentUseCaseParams(magnetLink: magnetLink),
      cancelToken: CancelToken(),
    );

    TorrentAddedResponse? result;
    response.when(
      success: (torrentResponse) async {
        final torrents = await _engine.fetchTorrents();
        _allTorrents = torrents;
        emit(
          state.copyWith(
            torrents: _filterByStatus(_allTorrents, _filterStatus),
          ),
        );
        result = torrentResponse;
      },
      failure: (_) {
        emit(state.copyWith(torrents: const []));
        result = null;
      },
    );
    return result;
  }

  bool _matchesFilter(
    TorrentStatus torrentStatus,
    TorrentDownloadStatus filterStatus,
  ) {
    switch (filterStatus) {
      case TorrentDownloadStatus.all:
        return true;
      case TorrentDownloadStatus.downloading:
        return torrentStatus == TorrentStatus.downloading ||
            torrentStatus == TorrentStatus.checking;
      case TorrentDownloadStatus.completed:
        return torrentStatus == TorrentStatus.seeding;
      case TorrentDownloadStatus.queued:
        return torrentStatus == TorrentStatus.queuedToCheck ||
            torrentStatus == TorrentStatus.queuedToDownload ||
            torrentStatus == TorrentStatus.queuedToSeed;
      case TorrentDownloadStatus.stopped:
        return torrentStatus == TorrentStatus.stopped;
    }
  }

  List<Torrent> _filterByStatus(
    List<Torrent> list,
    TorrentDownloadStatus filterStatus,
  ) {
    if (filterStatus == TorrentDownloadStatus.all) return list;
    final out = <Torrent>[];
    for (int i = 0; i < list.length; i++) {
      if (_matchesFilter(list[i].status, filterStatus)) out.add(list[i]);
    }
    return out;
  }

  TorrentDownloadStatus _getFilterFromTitle(String? raw) {
    if (raw == null || raw.isEmpty) return TorrentDownloadStatus.all;
    for (final v in TorrentDownloadStatus.values) {
      if (v.title == raw) return v;
    }
    return TorrentDownloadStatus.all;
  }

  void setFilterRaw(String? raw) {
    final next = _getFilterFromTitle(raw);
    if (next == _filterStatus) return;
    _filterStatus = next;
    if (state.status == DownloadStatus.error) return;
    emit(
      state.copyWith(
        torrents: _filterByStatus(_allTorrents, _filterStatus),
        selectedCategoryRaw: raw,
      ),
    );
  }

  Future<void> removeMultipleTorrents(Set<int> ids, bool keepFiles) async {
    if (ids.isEmpty) return;

    emit(state.copyWith(isBulkOperationInProgress: true));

    final torrentsToRemove = state.torrents
        .where((t) => ids.contains(t.id))
        .toList();

    if (torrentsToRemove.isEmpty) {
      emit(state.copyWith(isBulkOperationInProgress: false));
      return;
    }

    try {
      final withData = !keepFiles;
      for (int i = 0; i < torrentsToRemove.length; i++) {
        torrentsToRemove[i].remove(withData);
      }

      final torrents = await _engine.fetchTorrents();
      _allTorrents = torrents;

      emit(
        state.copyWith(
          isBulkOperationInProgress: false,
          torrents: _filterByStatus(_allTorrents, _filterStatus),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isBulkOperationInProgress: false));
    }
  }
}
