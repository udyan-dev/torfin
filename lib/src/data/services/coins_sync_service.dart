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

  bool _isCoinsSyncing = false;
  bool _isShareSyncing = false;

  Future<void> syncCoinsOnAppStart() async {
    try {
      final deviceId = await _deviceService.getDeviceId();
      if (deviceId == null) return;

      final remoteData = await _coinsRemoteSource.getCoinsWithTimestamp(
        deviceId,
      );
      if (remoteData == null) {
        final (localCoinsResult, localShareResult) = await (
          _storageRepository.getCoins(),
          _storageRepository.getShareCount(),
        ).wait;

        if (localCoinsResult case DataSuccess<int>(:final data?)) {
          final shareCount = localShareResult is DataSuccess<int>
              ? localShareResult.data ?? 0
              : 0;
          unawaited(
            _coinsRemoteSource.setCoins(deviceId, data, share: shareCount),
          );
        }
        return;
      }

      final (localCoinsResult, localShareResult, localTimestamp) = await (
        _storageRepository.getCoins(),
        _storageRepository.getShareCount(),
        _getLocalCoinsTimestamp(),
      ).wait;

      if (localCoinsResult case DataSuccess<int>(:final data?)) {
        final remoteTimestamp = remoteData.timestamp;

        if (remoteTimestamp > localTimestamp) {
          unawaited(
            Future.wait([
              _storageRepository.setCoins(remoteData.coins),
              _storageRepository.setShareCount(remoteData.share),
            ]),
          );
        } else if (localTimestamp > remoteTimestamp) {
          final shareCount = localShareResult is DataSuccess<int>
              ? localShareResult.data ?? 0
              : 0;
          unawaited(
            _coinsRemoteSource.setCoins(deviceId, data, share: shareCount),
          );
        }
      } else {
        unawaited(
          Future.wait([
            _storageRepository.setCoins(remoteData.coins),
            _storageRepository.setShareCount(remoteData.share),
          ]),
        );
      }
    } catch (_) {}
  }

  Future<int> _getLocalCoinsTimestamp() async {
    try {
      final timestamp = await _storageRepository.getCoinsTimestamp();
      if (timestamp case DataSuccess<int>(:final data?)) {
        return data;
      }
    } catch (_) {}
    return 0;
  }

  Future<void> syncCoinsAfterChange(int coins) async {
    if (_isCoinsSyncing) return;
    _isCoinsSyncing = true;
    try {
      final (hasInternet, deviceId, shareResult) = await (
        _connectivityService.hasInternet,
        _deviceService.getDeviceId(),
        _storageRepository.getShareCount(),
      ).wait;

      if (!hasInternet || deviceId == null) return;
      final share = shareResult is DataSuccess<int> ? shareResult.data ?? 0 : 0;
      await _coinsRemoteSource.setCoins(deviceId, coins, share: share);
    } catch (_) {
    } finally {
      _isCoinsSyncing = false;
    }
  }

  Future<void> syncShareCountAfterChange(int count) async {
    if (_isShareSyncing) return;
    _isShareSyncing = true;
    try {
      final (hasInternet, deviceId, coinsResult) = await (
        _connectivityService.hasInternet,
        _deviceService.getDeviceId(),
        _storageRepository.getCoins(),
      ).wait;

      if (!hasInternet || deviceId == null) return;
      final coins = coinsResult is DataSuccess<int> ? coinsResult.data ?? 0 : 0;
      await _coinsRemoteSource.setCoins(deviceId, coins, share: count);
    } catch (_) {
    } finally {
      _isShareSyncing = false;
    }
  }

  Future<void> syncCoinsOnAppClose() async {
    try {
      final (deviceId, localCoins, localShare) = await (
        _deviceService.getDeviceId(),
        _storageRepository.getCoins(),
        _storageRepository.getShareCount(),
      ).wait;

      if (deviceId == null) return;
      if (localCoins case DataSuccess<int>(:final data?)) {
        final share = localShare is DataSuccess<int> ? localShare.data ?? 0 : 0;
        unawaited(_coinsRemoteSource.setCoins(deviceId, data, share: share));
      }
    } catch (_) {}
  }
}
