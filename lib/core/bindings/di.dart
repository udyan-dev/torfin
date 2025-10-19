import 'dart:async' show unawaited;

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../src/data/engine/engine.dart';
import '../../src/data/engine/models/session.dart';
import '../../src/data/engine/transmission/transmission.dart';
import '../../src/data/repositories/storage_repository_impl.dart';
import '../../src/data/repositories/torrent_repository_impl.dart';
import '../../src/data/services/coins_sync_service.dart';
import '../../src/data/sources/local/storage_service.dart';
import '../../src/data/sources/remote/coins_remote_source.dart';
import '../../src/data/sources/remote/dio_service.dart';
import '../../src/domain/repositories/storage_repository.dart';
import '../../src/domain/repositories/torrent_repository.dart';
import '../../src/domain/usecases/add_torrent_use_case.dart';
import '../../src/domain/usecases/auto_complete_use_case.dart';
import '../../src/domain/usecases/favorite_use_case.dart';
import '../../src/domain/usecases/get_magnet_use_case.dart';
import '../../src/domain/usecases/get_token_use_case.dart';
import '../../src/domain/usecases/search_torrent_use_case.dart';
import '../../src/domain/usecases/trending_torrent_use_case.dart';
import '../../src/presentation/download/cubit/download_cubit.dart';
import '../../src/presentation/favorite/cubit/favorite_cubit.dart';
import '../../src/presentation/home/cubit/home_cubit.dart';
import '../../src/presentation/search/cubit/search_cubit.dart';
import '../../src/presentation/settings/cubit/settings_cubit.dart';
import '../../src/presentation/trending/cubit/trending_cubit.dart';
import '../../src/presentation/widgets/coins/cubit/coins_cubit.dart';
import '../services/connectivity_service.dart';
import '../services/device_service.dart';
import '../services/intent_handler.dart';
import '../services/notification_service.dart';
import '../services/theme_service.dart';
import '../utils/string_constants.dart';

final di = GetIt.instance;

Future<void> get initDI async {
  di.registerLazySingleton(() => const Uuid());
  di.registerLazySingleton(() => StorageService());
  di.registerLazySingleton(() => ConnectivityService());
  di.registerFactory(() => CancelToken());
  di.registerLazySingleton(
    () => Dio(
      BaseOptions(
        sendTimeout: timeoutDuration,
        receiveTimeout: timeoutDuration,
      ),
    ),
  );
  di.registerLazySingleton(() => DioService(dio: di()));
  di.registerLazySingleton(() => SessionService());

  di.registerLazySingleton(() => DeviceService(storageService: di()));
  di.registerLazySingleton(() => CoinsRemoteSource(connectivityService: di()));

  final storageRepo = StorageRepositoryImpl(storageService: di());
  di.registerSingleton<StorageRepository>(
    storageRepo,
    dispose: (storageRepository) => storageRepository.dispose(),
  );
  di.registerLazySingleton<TorrentRepository>(
    () => TorrentRepositoryImpl(dioService: di()),
  );

  final coinsSyncService = CoinsSyncService(
    deviceService: di(),
    coinsRemoteSource: di(),
    storageRepository: storageRepo,
    connectivityService: di(),
  );
  di.registerSingleton(coinsSyncService);
  storageRepo.setCoinsSyncService(coinsSyncService);

  final themeService = ThemeService(storageRepository: di());
  final engine = TransmissionEngine();

  await Future.wait([themeService.init(), engine.init()]);

  await engine.restoreTorrentsResumeStatus();
  di.registerSingleton<ThemeService>(themeService, dispose: (s) => s.dispose());
  di.registerSingleton<Engine>(engine, dispose: (e) => e.dispose());

  final notificationService = NotificationService(engine);
  await notificationService.init();
  di.registerSingleton<NotificationService>(
    notificationService,
    dispose: (s) => s.stop(),
  );

  final intentHandler = IntentHandler();
  await intentHandler.init();
  di.registerSingleton<IntentHandler>(
    intentHandler,
    dispose: (h) => h.dispose(),
  );

  di.registerLazySingleton(
    () => GetTokenUseCase(torrentRepository: di(), storageRepository: di()),
  );
  di.registerLazySingleton(
    () => SearchTorrentUseCase(
      torrentRepository: di(),
      storageRepository: di(),
      uuid: di(),
    ),
  );
  di.registerLazySingleton(() => FavoriteUseCase(storageRepository: di()));
  di.registerLazySingleton(() => AutoCompleteUseCase(torrentRepository: di()));
  di.registerLazySingleton(() => GetMagnetUseCase(torrentRepository: di()));
  di.registerLazySingleton(
    () => AddTorrentUseCase(
      engine: di(),
      storageRepository: di(),
      getMagnetUseCase: di(),
    ),
  );
  di.registerLazySingleton(
    () => TrendingTorrentUseCase(
      torrentRepository: di(),
      storageRepository: di(),
    ),
  );

  di.registerSingleton(
    CoinsCubit(storageRepository: di(), coinsSyncService: di())..load(),
  );
  unawaited(di<CoinsSyncService>().syncCoinsOnAppStart());

  di.registerFactory(
    () => HomeCubit(
      getTokenUseCase: di(),
      cancelToken: di(),
      notificationService: di(),
      intentHandler: di(),
    ),
  );
  di.registerFactory(
    () => SearchCubit(
      searchTorrentUseCase: di(),
      autoCompleteUseCase: di(),
      favoriteUseCase: di(),
      addTorrentUseCase: di(),
      getMagnetUseCase: di(),
      storageRepository: di(),
    ),
  );
  di.registerFactory(
    () => TrendingCubit(
      trendingUseCase: di(),
      favoriteUseCase: di(),
      addTorrentUseCase: di(),
      getMagnetUseCase: di(),
    ),
  );
  di.registerFactory(
    () => FavoriteCubit(
      favoriteUseCase: di(),
      addTorrentUseCase: di(),
      getMagnetUseCase: di(),
    ),
  );
  di.registerFactory(
    () => DownloadCubit(engine: di(), addTorrentUseCase: di()),
  );
  di.registerFactory(
    () => SettingsCubit(
      storageRepository: di(),
      sessionService: di(),
      engine: di(),
    ),
  );
}
