import 'dart:async';

import '../../../core/helpers/data_state.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/device_service.dart';
import '../repositories/storage_repository_impl.dart';
import '../sources/remote/coins_remote_source.dart';

class CoinsSyncService {
  CoinsSyncService({
    required DeviceService deviceService,
    required CoinsRemoteSource coinsRemoteSource,
    required StorageRepositoryImpl storageRepository,
    required ConnectivityService connectivityService,
  }) : _deviceService = deviceService,
       _coinsRemoteSource = coinsRemoteSource,
       _storageRepository = storageRepository,
       _connectivityService = connectivityService;

  final DeviceService _deviceService;
  final CoinsRemoteSource _coinsRemoteSource;
  final StorageRepositoryImpl _storageRepository;
  final ConnectivityService _connectivityService;

  Future<void> syncCoinsOnAppStart() async {
    try {
      final deviceId = await _deviceService.getDeviceId();
      if (deviceId == null) return;

      final remoteData = await _coinsRemoteSource.getCoinsWithTimestamp(
        deviceId,
      );
      if (remoteData == null) {
        final localResult = await _storageRepository.getCoins();
        if (localResult case DataSuccess<int>(:final data?)) {
          unawaited(_coinsRemoteSource.setCoins(deviceId, data));
        }
        return;
      }

      final localResult = await _storageRepository.getCoins();
      if (localResult case DataSuccess<int>(:final data?)) {
        final remoteTimestamp = remoteData.timestamp;
        final localTimestamp = await _getLocalTimestamp();
        if (remoteTimestamp > localTimestamp) {
          unawaited(_storageRepository.setCoins(remoteData.coins));
        } else if (localTimestamp > remoteTimestamp) {
          unawaited(_coinsRemoteSource.setCoins(deviceId, data));
        }
      } else {
        unawaited(_storageRepository.setCoins(remoteData.coins));
      }
    } catch (_) {}
  }

  Future<int> _getLocalTimestamp() async {
    try {
      final timestamp = await _storageRepository.getCoinsTimestamp();
      if (timestamp case DataSuccess<int>(:final data?)) {
        return data;
      }
    } catch (_) {}
    return 0;
  }

  Future<void> syncCoinsAfterChange(int coins) async {
    try {
      if (!await _connectivityService.hasInternet) return;
      final deviceId = await _deviceService.getDeviceId();
      if (deviceId == null) return;
      await _coinsRemoteSource.setCoins(deviceId, coins);
    } catch (_) {}
  }

  Future<void> syncCoinsOnAppClose() async {
    try {
      final deviceId = await _deviceService.getDeviceId();
      if (deviceId == null) return;
      final localCoins = await _storageRepository.getCoins();
      if (localCoins case DataSuccess<int>(:final data?)) {
        unawaited(_coinsRemoteSource.setCoins(deviceId, data));
      }
    } catch (_) {}
  }
}
