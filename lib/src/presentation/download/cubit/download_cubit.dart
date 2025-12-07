import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/helpers/base_exception.dart';
import '../../../../core/helpers/data_state.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/engine/engine.dart';
import '../../../data/engine/session.dart';
import '../../../data/engine/torrent.dart';
import '../../../domain/usecases/add_torrent_use_case.dart';
import '../../../domain/usecases/share_torrent_use_case.dart';
import '../../shared/notification_builders.dart';
import '../../widgets/notification_widget.dart';

part 'download_cubit.freezed.dart';
part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final Engine _engine;
  final AddTorrentUseCase _addTorrentUseCase;
  final ShareTorrentUseCase _shareTorrentUseCase;
  Timer? _refreshTimer;
  bool _isFetching = false;

  List<Torrent> _allTorrents = const <Torrent>[];
  TorrentDownloadStatus _filterStatus = TorrentDownloadStatus.all;

  DownloadCubit({
    required Engine engine,
    required AddTorrentUseCase addTorrentUseCase,
    required ShareTorrentUseCase shareTorrentUseCase,
  }) : _engine = engine,
       _addTorrentUseCase = addTorrentUseCase,
       _shareTorrentUseCase = shareTorrentUseCase,
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
    } catch (e) {
      emit(state.copyWith(status: DownloadStatus.error));
    }
  }

  void startAutoRefresh({Duration interval = const Duration(seconds: 1)}) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(interval, (_) async {
      if (_isFetching || isClosed) return;
      _isFetching = true;
      try {
        final torrents = await _engine.fetchTorrents();
        if (isClosed) return;
        _allTorrents = torrents;
        emit(
          state.copyWith(
            torrents: _filterByStatus(_allTorrents, _filterStatus),
          ),
        );
      } catch (_) {
      } finally {
        _isFetching = false;
      }
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
        try {
          final torrents = await _engine.fetchTorrents();
          _allTorrents = torrents;
          emit(
            state.copyWith(
              torrents: _filterByStatus(_allTorrents, _filterStatus),
            ),
          );
        } catch (_) {}
        result = torrentResponse;
      },
      failure: (_) {
        emit(state.copyWith(torrents: const []));
        result = null;
      },
    );
    return result;
  }

  /// Retries a torrent with an error. Checks for coins first.
  /// Returns true if retry was successful, false if insufficient coins.
  Future<bool> retryTorrent(Torrent torrent, BuildContext context) async {
    final hasCoins = await _addTorrentUseCase.hasCoins();
    if (!hasCoins) {
      if (context.mounted) {
        NotificationWidget.notify(context, insufficientCoinsNotification());
      }
      return false;
    }
    final magnetLink = torrent.magnetLink;
    await torrent.remove(true);
    await addTorrent(magnetLink);
    return true;
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
        await torrentsToRemove[i].remove(withData);
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

  Future<void> shareTorrent(Torrent torrent, BuildContext context) async {
    final result = await _shareTorrentUseCase.call(
      ShareTorrentUseCaseParams(
        magnetLink: torrent.magnetLink,
        torrentName: torrent.name,
      ),
      cancelToken: CancelToken(),
    );

    if (isClosed) return;

    result.when(
      success: (_) {
        if (context.mounted) {
          Navigator.of(context).maybePop();
        }
      },
      failure: (error) {
        if (context.mounted) {
          Navigator.of(context).maybePop();
        }
        if (error.type == BaseExceptionType.insufficientCoins) {
          if (context.mounted) {
            NotificationWidget.notify(context, insufficientCoinsNotification());
          }
        } else {
          if (context.mounted) {
            NotificationWidget.notify(
              context,
              AppNotification(
                type: NotificationType.error,
                message: error.message,
              ),
            );
          }
        }
      },
    );
  }
}
