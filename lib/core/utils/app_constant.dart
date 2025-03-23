import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:torfin/gen/assets.gen.dart';
import 'package:torfin/src/presentation/widgets/circular_progress_widget.dart';

class AppConstant {
  static const String torfin = "Torfin";
  static const String token = "TOKEN";
  static const String nsfw = "NSFW";
  static const String theme = "THEME";
  static const String saveTorrent = "USER_FAV";
  static const String storage = "STORAGE_PATH";
  static final RegExp regexForKey = RegExp(
    r'findNextItem.*?"(.*?)"',
    dotAll: true,
  );

  /// Regex For JS for parsing API TOKEN -> [regexForJs]
  static final RegExp regexForJs = RegExp(r'(b.min.js.*)(?=")');

  static final RegExp regexMagnet = RegExp(r'magnet:\?xt=urn:btih:[a-zA-Z0-9]+');

  static const baseUrl = 'https://snowfl.com/';

  static const timeoutDuration = Duration(seconds: 60);

  static const empty = SizedBox.shrink();

  static const circularProgress = CircularProgressWidget();

  /// STRINGS
  static const noInternetFound = "Oops! No internet found";
  static const serverNotReachable = "Server not Reachable !";
  static const connectingToServer = "Connecting to server...";
  static const permissionGranted = "Permission Granted !";
  static const permissionDenied = "Permission Denied !";
  static final baseOptions = BaseOptions(
    connectTimeout: AppConstant.timeoutDuration,
    receiveTimeout: AppConstant.timeoutDuration,
    sendTimeout: AppConstant.timeoutDuration,
  );
}

enum SortType {
  none("Relevance", "NONE"),
  age("Recent", "DATE"),
  seeds("Seeds", "SEED"),
  leeches("Leeches", "LEECH"),
  sizeAsc("Size Asc", "SIZE_ASC"),
  sizeDsc("Size Desc", "SIZE");

  final String title;
  final String value;

  const SortType(this.title, this.value);
}

enum TrendingType {
  day("24", "Today"),
  week("168", "This Week"),
  month("720", "This Month");

  final String value;
  final String title;

  const TrendingType(this.value, this.title);
}

enum TorrentType {
  all("All", ['all']),
  app("Apps", ['app']),
  anime("Anime", ['anime']),
  audio("Audio", ['audio']),
  document("Docs", ['doc', 'document']),
  book("Books", ['book']),
  game("Games", ['game']),
  music("Music", ['music']),
  movie("Movie", ['movie']),
  tv("TV", ['tv']),
  video("Video", ['video']),
  other("Other", []);

  final String title;
  final List<String> keywords;

  const TorrentType(this.title, this.keywords);

  static final Map<String, TorrentType> _lookup = {
    for (var type in TorrentType.values)
      for (var keyword in type.keywords) keyword: type,
  };

  static SvgGenImage getSvg(String input) {
    input = input.toLowerCase();
    return _lookup.entries
        .firstWhere(
          (entry) => input.contains(entry.key),
          orElse: () => MapEntry('', TorrentType.other),
        )
        .value
        .icon;
  }

  SvgGenImage get icon {
    switch (this) {
      case TorrentType.all:
        return AppAsset.svg.icTrending;
      case TorrentType.app:
        return AppAsset.svg.icApp;
      case TorrentType.anime:
        return AppAsset.svg.icAnime;
      case TorrentType.audio:
        return AppAsset.svg.icAudio;
      case TorrentType.document:
        return AppAsset.svg.icDoc;
      case TorrentType.book:
        return AppAsset.svg.icBook;
      case TorrentType.game:
        return AppAsset.svg.icGame;
      case TorrentType.music:
        return AppAsset.svg.icMusic;
      case TorrentType.movie:
        return AppAsset.svg.icMovie;
      case TorrentType.tv:
        return AppAsset.svg.icTv;
      case TorrentType.video:
        return AppAsset.svg.icVideo;
      default:
        return AppAsset.svg.icOther;
    }
  }

  static TorrentType fromJson(String? value) {
    if (value == null || value.isEmpty) return TorrentType.other;
    final lowerInput = value.toLowerCase();
    return _lookup.entries
        .where((entry) => lowerInput.contains(entry.key))
        .fold<MapEntry<String, TorrentType>>(MapEntry('', TorrentType.other), (
          closest,
          current,
        ) {
          final index = lowerInput.indexOf(current.key);
          return (index != -1 &&
                  (closest.key.isEmpty ||
                      index < lowerInput.indexOf(closest.key)))
              ? current
              : closest;
        })
        .value;
  }

  static String toJson(TorrentType type) {
    return _lookup.entries
        .firstWhere(
          (entry) => entry.value == type,
          orElse: () => MapEntry('other', TorrentType.other),
        )
        .key;
  }
}
