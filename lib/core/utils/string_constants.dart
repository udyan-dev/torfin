import 'dart:io';

import 'package:flutter/material.dart';

import '../bindings/env.dart';
import 'app_assets.dart';

const String appName = 'Torfin';
const String zone = 'ZONE';
const String ibmPlexMono = 'IBM Plex Mono';
const String ibmPlexSans = 'IBM Plex Sans';
const List<({String label, String icon})> navigationItems = [
  (label: 'Search', icon: AppAssets.icSearch),
  (label: 'Trending', icon: AppAssets.icTrending),
  (label: 'Downloads', icon: AppAssets.icDownload),
  (label: 'Favorite', icon: AppAssets.icFavorite),
  (label: 'Settings', icon: AppAssets.icSettings),
];
const String requestCancelledMessage = 'Request Cancelled !';
const String connectionFailedMessage = 'Connection Failed !';
const String sendTimeoutMessage = 'Send Timeout !';
const String receiveTimeoutMessage = 'Receive Timeout !';
const String badResponseMessage = 'Bad Response !';
const String noInternetError = 'No Internet Connection !';
const String serverConnectionError = 'Server Connection Error !';
const String unknownErrorMessage = 'Unknown Error !';
const String badCertificateMessage = 'Bad Certificate !';
const String parseDataError = 'Parse Data Error !';
const String getRequestError = 'GET Request Failed !';
final RegExp regexForKey = RegExp('findNextItem.*?"(.*?)"', dotAll: true);
final RegExp regexForJs = RegExp('(b.min.js.*)(?=")');
final RegExp regexMagnet = RegExp('magnet:\\?xt=urn:btih:[a-zA-Z0-9]+');
const String emptyString = '';
const String unsupportedTypeError = 'Unsupported Type Error !';
const String tokenKey = 'token';
const String themeKey = 'theme';
const String nsfwKey = 'nsfw';
const String storageExceptionPrefix = 'StorageException: ';

const String userAgentHeader = 'user-agent';
const String acceptHeader = 'accept';
const String acceptLanguageHeader = 'accept-language';
const String dntHeader = 'dnt';
const String priorityHeader = 'priority';
const String refererHeader = 'referer';
const String secChUaHeader = 'sec-ch-ua';
const String secChUaMobileHeader = 'sec-ch-ua-mobile';
const String secChUaPlatformHeader = 'sec-ch-ua-platform';
const String secFetchDestHeader = 'sec-fetch-dest';
const String secFetchModeHeader = 'sec-fetch-mode';
const String secFetchSiteHeader = 'sec-fetch-site';
const String xRequestedWithHeader = 'x-requested-with';

const String userAgentValue = 'Mozilla/5.0 (Linux; Android ';
const String acceptValue = 'application/json, text/javascript, */*; q=0.01';
const String acceptLanguageValue = 'en-US,en;q=0.9,en-IN;q=0.8';
const String dntValue = '1';
const String priorityValue = 'u=1, i';
const String secChUaValue = '"Not(A:Brand";v="99", "Chromium";v="133"';
const String secChUaMobileValue = '?1';
const String secChUaPlatformValue = '"Android"';
const String secFetchDestValue = 'empty';
const String secFetchModeValue = 'cors';
const String secFetchSiteValue = 'same-origin';
const String xRequestedWithValue = 'XMLHttpRequest';

const timeoutDuration = Duration(seconds: 60);

final Map<String, String> torrentHeaders = {
  userAgentHeader: '$userAgentValue${Platform.operatingSystemVersion})',
  acceptHeader: acceptValue,
  acceptLanguageHeader: acceptLanguageValue,
  dntHeader: dntValue,
  priorityHeader: priorityValue,
  refererHeader: Env.baseUrl,
  secChUaHeader: secChUaValue,
  secChUaMobileHeader: secChUaMobileValue,
  secChUaPlatformHeader: secChUaPlatformValue,
  secFetchDestHeader: secFetchDestValue,
  secFetchModeHeader: secFetchModeValue,
  secFetchSiteHeader: secFetchSiteValue,
  xRequestedWithHeader: xRequestedWithValue,
};

const String torrentDio = 'torrentDio';
const String generalDio = 'generalDio';
const String repositoryError = 'Repository Error !';
const String apiKeyExtractionError = 'Failed to extract API key from response';
const String tokenExtractionError = 'Failed to extract token from response';
const String apiKeyFetchError = 'Failed to fetch API key';
const String tokenFetchError = 'Failed to fetch token';
const String getTokenError = 'Failed to get token';
const String connectingToServer = 'Connecting to server...';
const String retry = "Retry";
const String failedToConnectToServer =
    'Failed to connect to server. Check your internet connection or try again later.';
const String search = "Search";
const String hintText = 'Search Torrents';
const emptyBox = SizedBox.shrink();
const String sortBy = 'Sort By';
const String cancel = 'Cancel';
const String apply = 'Apply';
const String searchTorrentsTitle = 'Find Any Torrent !';
const String searchTorrentsDescription =
    'Search for movies, TV shows, music, games, software, books, documents and more from millions of torrents available worldwide.';
const String noResultsFoundTitle = 'No Torrents were Found !';
const String noResultsFoundDescription =
    'We couldn\'t find any torrents matching your search. Try different keywords or check your spelling.';
const String seeder = 'Seeder';
const String leecher = 'Leecher';
const String size = 'Size';
const String age = 'Age';
const String loadingMore = 'Loading more...';
const String trending = 'Trending';
