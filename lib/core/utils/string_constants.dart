import 'dart:io';

import 'package:flutter/material.dart';

import '../bindings/env.dart';
import 'app_assets.dart';

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
const String tokenKey = 'token';
const String themeKey = 'theme';
const String nsfwKey = 'nsfw';
const String enableSuggestionsKey = 'enableSuggestions';
const String favoritesKey = 'favorites';
const String sortKey = 'sort';
const String reverseSortKey = 'reverseSort';
const String storageExceptionPrefix = 'StorageException: ';
const String downloadLocationKey = 'downloadLocation';
const String coinsKey = 'coins';
const int initialCoins = 10;
const int coinsPerAd = 10;
const int maxCoins = 10;
const String shareCountKey = 'shareCount';
const int sharesPerCoin = 4;
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
const String save = 'Save';
const String remove = 'Remove';
const String download = 'Download';
const String downloads = 'Downloads';
const String favorite = 'Favorite';
const String saveYourFavoriteTorrents = 'Save your favorite torrents !';
const String addTorrentsToYourFavorites =
    'Add torrents to your favorites list to quickly find and download them later.';
const String noDownloadsYet = 'No Downloads Yet !';
const String startDownloadingTorrents =
    'Your downloads will appear here once you start. Search for torrents and add them to begin downloading.';
const String nothingDownloading = 'No Torrents Downloading !';
const String nothingCompleted = 'No Torrents Completed !';
const String nothingQueued = 'No Torrents Queued !';
const String nothingStopped = 'No Torrents Stopped !';
const String wasAddedToFavorites = 'Was added to favorites';
const String wasRemovedFromFavorites = 'Was removed from favorites';
const String storagePermissionNotGranted = 'Storage permission not granted';
const String pleaseGrantStoragePermission =
    'Please grant storage permission to download torrents';
const String somethingWentWrong = 'Something went wrong !';
const String magnetLinkNotFound = 'Magnet link not found';
const String downloadStartedSuccessfully = 'Download started successfully';
const String torrentAlreadyExists = 'Torrent already exists';
const String failedToStartDownloadPrefix = 'Failed to start download: ';
const String allTitle = 'All';
const String downloadingTitle = 'Downloading';
const String completedTitle = 'Completed';
const String queuedTitle = 'Queued';
const String stoppedTitle = 'Stopped';
const String selectAll = 'Select All';
const String files = 'Files';
const String details = 'Details';
const String error = 'Error';
const String nameLabel = 'Name';
const String idLabel = 'ID';
const String labelsLabel = 'Labels';
const String statusLabel = 'Status';
const String progressLabel = 'Progress';
const String downloadedLabel = 'Downloaded';
const String uploadedLabel = 'Uploaded';
const String downloadRateLabel = 'Download rate';
const String uploadRateLabel = 'Upload rate';
const String remainingTimeLabel = 'Remaining time';
const String locationLabel = 'Location';
const String privateLabel = 'Private';
const String addedDateLabel = 'Added date';
const String creatorLabel = 'Creator';
const String commentLabel = 'Comment';
const String peersConnectedLabel = 'Peers connected';
const String sequentialDownloadLabel = 'Sequential download';
const String fileCountLabel = 'File count';
const String pieceCountLabel = 'Piece count';
const String pieceSizeLabel = 'Piece size';
const String piecesLabel = 'Pieces';
const String yesLabel = 'Yes';
const String noLabel = 'No';
const String dash = '-';
const String commaSeparator = ', ';
const String perSecondSuffix = '/s';
const String percentSuffix = '%';
const String delete = 'Delete';
const String deleteConfirmationMessage =
    'Are you sure you want to delete this torrent ?';
const String keepFilesAndRemoveTorrentOnly =
    'Keep files and remove torrent only';
const String settings = 'Settings';
const String chooseYourTheme = 'Choose your theme';
const String themeLight = 'Light';
const String themeSystem = 'System';
const String themeDark = 'Dark';
const String enableSuggestionsWhileSearching =
    'Enable suggestions while searching';
const String showNSFWTorrent = 'Show NSFW (not safe for view) torrent';
const String enableSpeedLimits = 'Enable speed limits';
const String streamingMightNotWorkCorrectly =
    'Streaming might not work correctly if speed limits are enabled.';
const String downloadSpeedKbps = 'Download Speed ( KBps )';
const String uploadSpeedKbps = 'Upload Speed ( KBps )';
const String enterANumber = 'Enter a number';
const String downloadSpeedLimit = 'Download speed limit';
const String uploadSpeedLimit = 'Upload speed limit';
const String maximumActiveDownloads = 'Maximum active downloads';
const String maxDownloads = 'Max Downloads';
const String listeningPort = 'Listening port';
const String incomingPort = 'Incoming Port';
const String failedToUpdateSettings = 'Failed to update settings: ';
const String resetTorrentSettings = 'Reset torrent settings';
const String areYouSureResetSettings =
    'Are you sure you want to reset all torrent settings?';
const String yes = 'Yes';
const String failedToResetSettings = 'Failed to reset settings: ';
const String rateTheApp = 'Support us by rating the app !';
const String failedToOpenPlayStore = 'Failed to open Play Store';
const String appVersion = 'App version';
const String appVersionNumber = '2.0.0';
const String privacyPolicy = 'Privacy policy';
const String privacyPolicyUrl =
    'https://udyan-dev.github.io/torfin-privacy-policy/';
const String speedUnitKBps = 'KBps';
const String defaultSpeedValue = '∞';
const String defaultPortValue = '0';
const String nsfwEnabledValue = '1';
const String nsfwDisabledValue = '0';
const String notificationChannelId = 'torrent_downloads';
const String notificationChannelName = 'Torrent Downloads';
const String notificationActive = 'Active';
const String notificationPaused = 'Paused';
const String notificationPause = 'Pause';
const String notificationResume = 'Resume';
const String notificationPauseAll = 'Pause All';
const String notificationResumeAll = 'Resume All';
const String notificationInfinity = '∞';
const String notificationSeparator = ' • ';
const String notificationPercentSuffix = '%';
const String notificationSpeedSuffix = '/s';
const String torrentSuffix = 'torrent';
const String torrentsSuffix = 'torrents';
const String all = 'All';
const String downloadAll = 'Download All';
const String removeAll = 'Remove All';
const String saveAll = 'Save All';
const String deleteAll = 'Delete All';
const String areYouSureYouWantToDownloadAllSelectedTorrents =
    'Are you sure you want to download all selected torrents ?';
const String areYouSureYouWantToRemoveAllSelectedTorrents =
    'Are you sure you want to remove all selected torrents ?';
const String areYouSureYouWantToSaveAllSelectedTorrents =
    'Are you sure you want to save all selected torrents ?';
const String failedToRemoveFavorites = 'Failed to remove favorites';
const String failedToAddFavorites = 'Failed to add favorites';
const String torrentsWereRemovedFromFavorites =
    'Torrents were removed from favorites';
const String torrentsWereAddedToFavorites = 'Torrents were added to favorites';
const String torrentWasAlreadyInFavorites = 'Torrent was already in favorites';
const String torrentsWereAlreadyInFavorites =
    'Torrents were already in favorites';
const String torrentsWereAddedToDownload = 'Torrents were added to download';
const String successSuffix = 'success';
const String failedToDownloadTorrents = 'failed to download torrents';
const String torrentsWereDeleted = 'Torrents were deleted';
const String insufficientCoins = 'Insufficient coins';
const String watchAdForCoins = 'Watch Ad for Coins';
const String watchAdMessage =
    'Watch a rewarded ad to get $coinsPerAd coins and continue downloading and sharing !';
const String watchAd = 'Watch Ad';
const String coinsAdded = 'Coins added successfully';
const String adFailedToLoad =
    'Failed to load ad. Please try again after some time.';
const String adBlockerOrInternetMessage =
    'Please disable AdBlocker or check your internet connection to load the ad';
const String coinsInfoMessage =
    'Each download costs 1 coin. Each share costs 0.25 coins. Watch ads when coins reach zero to continue.';
const String failedToDeleteTorrents = 'Failed to delete torrents';
const String failedToRetrieveCoins = 'Failed to retrieve coins';
const String failedToAddTorrent = 'Failed to add torrent';
const String torrentWasNotDownloaded =
    'torrent was not downloaded due to insufficient coins';
const String torrentsWereNotDownloaded =
    'torrents were not downloaded due to insufficient coins';
const String areYouSureYouWantToDeleteAllSelectedTorrents =
    'Are you sure you want to delete all selected torrents ?';
const String oneCoinRequiredToDownload =
    '1 coin required to download and 0.25 coins required to share torrent';
const String coinRequiredToDownload = 'coin required to download';
const String coinsRequiredToDownload = 'coins required to download';
const String addTorrent = 'Add Torrent';
const String magnetOrHttpsHint = 'magnet:// or https://';
const String selectTorrentFile = 'Select .torrent file';
const String torrentAdded = 'Torrent added';
const String torrentAlreadyAdded = 'Torrent already added';
const String invalidTorrent = 'Invalid torrent';
const String failedToReadTorrentFile = 'Failed to read torrent file';
const String pleaseEnterMagnetOrSelectFile =
    'Please enter a magnet link or select a .torrent file';
const String or = 'or';
const String failedToRetrieveShareCount = 'Failed to retrieve share count';
const String shareFailedPrefix = 'Share failed: ';
const String gettingTorrentMetadata = 'Getting torrent metadata...';
