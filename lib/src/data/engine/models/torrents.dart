import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

import '../../../../core/bindings/di.dart';
import '../../../../core/utils/string_constants.dart';
import '../../sources/local/storage_service.dart';
import '../engine.dart';
import '../torrent.dart';

const refreshIntervalSeconds = 1;

enum Sort { addedDate, progress, size }

class Filters {
  Set<String> labels = {};

  Filters({required this.labels});

  bool get enabled {
    return labels.isNotEmpty;
  }

  Filters.copy(Filters other) : this(labels: Set.from(other.labels));

  void addLabel(String label) {
    labels.add(label);
  }

  void removeLabel(String label) {
    labels.remove(label);
  }
}

class TorrentsModel extends ChangeNotifier {
  // All loaded torrents
  List<Torrent> torrents = [];
  List<Torrent> displayedTorrents = []; // filtered & sorted
  // All torrents labels
  List<String> labels = [];
  String filterText = '';
  bool hasLoaded = false;
  Sort sort = Sort.addedDate;
  bool reverseSort = true;
  Filters filters = Filters(labels: {});
  late Timer _timer;

  TorrentsModel() {
    _init();
  }

  Future<void> _init() async {
    await _loadSettings();
    fetchTorrents();
    // Indefinitely refresh
    _timer = Timer.periodic(
      const Duration(seconds: refreshIntervalSeconds),
      (timer) => fetchTorrents(),
    );
  }

  void stopTimer() {
    _timer.cancel();
  }

  Future<void> _loadSettings() async {
    final storage = di<StorageService>();
    final results = await Future.wait<dynamic>([
      storage.get<String>(sortKey),
      storage.get<bool>(reverseSortKey),
    ]);
    final sortName = (results[0] as String?) ?? sort.name;
    sort = Sort.values.firstWhere(
      (e) => e.name == sortName,
      orElse: () => sort,
    );
    reverseSort = (results[1] as bool?) ?? reverseSort;
  }

  List<Torrent> _filterTorrentsName(List<Torrent> torrents) {
    return filterText.isNotEmpty
        ? extractAllSorted(
            query: filterText,
            choices: torrents.toList(),
            getter: (t) => t.name,
            cutoff: 60,
          ).map((result) => torrents[result.index]).toList()
        : torrents;
  }

  List<Torrent> _filterTorrents(List<Torrent> torrents) {
    if (filters.labels.isEmpty) return torrents;

    return torrents.where((t) {
      return filters.labels.every((l) => t.labels!.contains(l));
    }).toList();
  }

  List<Torrent> _sortTorrents(List<Torrent> torrents) {
    final torrentsSorted = List<Torrent>.from(torrents);
    switch (sort) {
      case Sort.addedDate:
        torrentsSorted.sort((a, b) => a.addedDate.compareTo(b.addedDate));
      case Sort.progress:
        torrentsSorted.sort((a, b) => a.progress.compareTo(b.progress));
      case Sort.size:
        torrentsSorted.sort((a, b) => a.size.compareTo(b.size));
    }
    return reverseSort ? torrentsSorted.reversed.toList() : torrentsSorted;
  }

  Future<TorrentAddedResponse> addTorrent(
    String? filename,
    String? metainfo,
    String? downloadDir,
  ) async {
    return di<Engine>().addTorrent(filename, metainfo, downloadDir);
  }

  Future<void> fetchTorrents() async {
    final DateTime now = DateTime.now();
    torrents = await di<Engine>().fetchTorrents();

    // Display notification for torrents completed during last refresh
    for (final torrent in torrents) {
      if (now.difference(torrent.doneDate).inSeconds < refreshIntervalSeconds) {
        /* showNotification(
            title: 'Download completed',
            body: torrent.name,
            notificationsDetailsType: NotificationsDetailsTypes
                .downloadsCompletedAndroidNotificationDetails);*/
      }
    }

    labels = torrents
        .fold<List<String>>(
          [],
          (previousValue, element) =>
              previousValue..addAll(element.labels ?? []),
        )
        .toSet()
        .toList();

    // Remove filtered labels that does not exist anymore
    for (final label in filters.labels) {
      if (!labels.contains(label)) {
        filters.removeLabel(label);
      }
    }

    if (!hasLoaded) {
      hasLoaded = true;
    }

    processDisplayedTorrents();
  }

  void processDisplayedTorrents() {
    displayedTorrents = _filterTorrents(
      _filterTorrentsName(_sortTorrents(torrents)),
    );
    notifyListeners();
  }

  void setFilterText(String value) {
    filterText = value;
    processDisplayedTorrents();
  }

  Future<void> setSort(Sort value, bool reverse) async {
    final storage = di<StorageService>();
    storage.set(sortKey, value.name);
    storage.set(reverseSortKey, reverse);
    sort = value;
    reverseSort = reverse;
    processDisplayedTorrents();
  }

  Future<void> setFilters(Filters updatedFilters) async {
    filters = updatedFilters;
    processDisplayedTorrents();
  }
}
