import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../src/data/engine/engine.dart';
import '../../src/data/engine/models/session.dart';
import '../../src/data/engine/transmission/transmission.dart';
import '../../src/data/repositories/storage_repository_impl.dart';
import '../../src/data/repositories/torrent_repository_impl.dart';
import '../../src/data/sources/local/storage_service.dart';
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
import '../services/theme_service.dart';
import '../utils/string_constants.dart';

final di = GetIt.instance;

Future<void> get initDI async {
  di.registerLazySingleton(() => const Uuid());
  di.registerLazySingleton(() => StorageService());
  di.registerLazySingleton(() => CancelToken());
  di.registerLazySingleton(
    () => Dio(
      BaseOptions(
        sendTimeout: timeoutDuration,
        receiveTimeout: timeoutDuration,
      ),
    ),
  );
  di.registerLazySingleton(() => DioService(dio: di<Dio>()));
  di.registerLazySingleton(() => SessionService());
  di.registerSingletonAsync<Engine>(() async {
    final e = TransmissionEngine();
    await e.init();
    await e.restoreTorrentsResumeStatus();
    return e;
  }, dispose: (e) => e.dispose());
  di.registerLazySingleton<StorageRepository>(
    () => StorageRepositoryImpl(storageService: di()),
  );
  di.registerLazySingleton<TorrentRepository>(
    () => TorrentRepositoryImpl(dioService: di()),
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
  di.registerLazySingleton(() => AddTorrentUseCase(engine: di()));
  di.registerLazySingleton(
    () => TrendingTorrentUseCase(
      torrentRepository: di(),
      storageRepository: di(),
    ),
  );
  di.registerLazySingleton(() => GetMagnetUseCase(torrentRepository: di()));
  di.registerFactory(() => HomeCubit(getTokenUseCase: di(), cancelToken: di()));
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
  di.registerSingletonAsync<ThemeService>(() async {
    final service = ThemeService(storageRepository: di());
    await service.init();
    return service;
  }, dispose: (service) => service.dispose());
}
