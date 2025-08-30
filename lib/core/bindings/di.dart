import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../src/data/repositories/storage_repository_impl.dart';
import '../../src/data/repositories/torrent_repository_impl.dart';
import '../../src/data/sources/local/storage_service.dart';
import '../../src/data/sources/remote/dio_service.dart';
import '../../src/domain/repositories/storage_repository.dart';
import '../../src/domain/repositories/torrent_repository.dart';
import '../../src/domain/usecases/auto_complete_use_case.dart';
import '../../src/domain/usecases/get_token_use_case.dart';
import '../../src/domain/usecases/search_torrent_use_case.dart';
import '../../src/domain/usecases/trending_torrent_use_case.dart';
import '../../src/domain/usecases/favorite_use_case.dart';
import '../../src/presentation/home/cubit/home_cubit.dart';
import '../../src/presentation/search/cubit/search_cubit.dart';
import '../../src/presentation/favorite/cubit/favorite_cubit.dart';
import '../../src/presentation/trending/cubit/trending_cubit.dart';
import '../utils/string_constants.dart';

final di = GetIt.instance;

Future<void> get init async {
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
  di.registerLazySingleton(
    () => TrendingTorrentUseCase(
      torrentRepository: di(),
      storageRepository: di(),
    ),
  );
  di.registerFactory(() => HomeCubit(getTokenUseCase: di(), cancelToken: di()));
  di.registerFactory(
    () => SearchCubit(
      searchTorrentUseCase: di(),
      autoCompleteUseCase: di(),
      favoriteUseCase: di(),
    ),
  );
  di.registerFactory(
    () => TrendingCubit(trendingUseCase: di(), favoriteUseCase: di()),
  );
  di.registerFactory(() => FavoriteCubit(favoriteUseCase: di()));
}
