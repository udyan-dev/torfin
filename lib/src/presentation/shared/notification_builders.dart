import '../../../core/utils/string_constants.dart';
import '../widgets/notification_widget.dart';

AppNotification favoriteNotification(String title, bool added) =>
    AppNotification(
      title: title,
      type: added
          ? NotificationType.favoriteAdded
          : NotificationType.favoriteRemoved,
      message: added ? wasAddedToFavorites : wasRemovedFromFavorites,
    );

AppNotification addStartedNotification(String title, bool isDuplicate) =>
    AppNotification(
      title: title,
      type: isDuplicate
          ? NotificationType.warning
          : NotificationType.downloadStarted,
      message: isDuplicate ? torrentAlreadyExists : downloadStartedSuccessfully,
    );

AppNotification magnetNotFoundNotification(String title) =>
    const AppNotification(
      type: NotificationType.error,
      message: magnetLinkNotFound,
    );

AppNotification addFailedNotification(String title, String errorMessage) =>
    AppNotification(
      title: title,
      type: NotificationType.error,
      message: '$failedToStartDownloadPrefix$errorMessage',
    );

AppNotification bulkRemoveSuccessNotification(int count) => AppNotification(
  title: '$count $torrentsWereRemovedFromFavorites',
  type: NotificationType.favoriteRemoved,
  message: emptyString,
);

AppNotification bulkRemoveFailedNotification(String message) => AppNotification(
  title: failedToRemoveFavorites,
  type: NotificationType.error,
  message: message,
);

AppNotification errorNotification(String title, String message) =>
    AppNotification(
      title: title,
      type: NotificationType.error,
      message: message,
    );

AppNotification bulkDeleteSuccessNotification(int count) => AppNotification(
  title: '$count $torrentsWereDeleted',
  type: NotificationType.favoriteRemoved,
  message: emptyString,
);

AppNotification bulkDeleteFailedNotification(String message) => AppNotification(
  title: failedToDeleteTorrents,
  type: NotificationType.error,
  message: message,
);

AppNotification insufficientCoinsNotification() => const AppNotification(
  title: insufficientCoins,
  type: NotificationType.error,
  message: emptyString,
);

AppNotification successNotification(String message) => AppNotification(
  title: message,
  type: NotificationType.downloadStarted,
  message: emptyString,
);
