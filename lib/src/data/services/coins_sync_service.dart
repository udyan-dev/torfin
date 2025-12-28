import 'dart:async';

import '../../../core/helpers/data_state.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/device_service.dart';
import '../../../core/utils/string_constants.dart';
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
  ({int coins, int timestamp})? _pendingCoinsSync;
  ({int count, int timestamp})? _pendingShareSync;

  Future<void> syncCoinsOnAppStart() async {
    try {
      final deviceId = await _deviceService.getDeviceId();
      if (deviceId == null) return;

      final (
        localCoinsResult,
        localShareResult,
        localCoinsTs,
        localShareTs,
      ) = await (
        _storageRepository.getCoins(),
        _storageRepository.getShareCount(),
        _getTimestamp(_storageRepository.getCoinsTimestamp),
        _getTimestamp(_storageRepository.getShareCountTimestamp),
      ).wait;

      final localCoins = localCoinsResult is DataSuccess<int>
          ? localCoinsResult.data ?? initialCoins
          : initialCoins;
      final localShare = localShareResult is DataSuccess<int>
          ? localShareResult.data ?? 0
          : 0;
      final localTimestamp = localCoinsTs > localShareTs
          ? localCoinsTs
          : localShareTs;

      final remoteData = await _coinsRemoteSource.getCoinsWithTimestamp(
        deviceId,
      );
      if (remoteData == null) {
        if (localTimestamp > 0) {
          unawaited(
            _syncToRemote(deviceId, localCoins, localShare, localTimestamp),
          );
        }
        return;
      }

      final remoteTimestamp = remoteData.timestamp > remoteData.shareTimestamp
          ? remoteData.timestamp
          : remoteData.shareTimestamp;

      if (localTimestamp >= remoteTimestamp && localTimestamp > 0) {
        unawaited(
          _syncToRemote(deviceId, localCoins, localShare, localTimestamp),
        );
      } else if (remoteTimestamp > localTimestamp) {
        await Future.wait([
          _storageRepository.setCoins(remoteData.coins),
          _storageRepository.setShareCount(remoteData.share),
        ]);
      }
    } catch (_) {}
  }

  Future<void> _syncToRemote(
    String deviceId,
    int coins,
    int share,
    int timestamp,
  ) async {
    try {
      await _coinsRemoteSource.setCoins(
        deviceId,
        coins,
        share: share,
        timestamp: timestamp,
      );
    } catch (_) {}
  }

  Future<int> _getTimestamp(Future<DataState<int>> Function() getter) async {
    try {
      final result = await getter();
      if (result case DataSuccess<int>(:final data?)) return data;
    } catch (_) {}
    return 0;
  }

  Future<void> syncCoinsAfterChange(int coins, int timestamp) async {
    _pendingCoinsSync = (coins: coins, timestamp: timestamp);
    if (_isCoinsSyncing) return;
    _isCoinsSyncing = true;
    try {
      while (_pendingCoinsSync != null) {
        final pending = _pendingCoinsSync!;
        _pendingCoinsSync = null;

        final (hasInternet, deviceId, shareResult) = await (
          _connectivityService.hasInternet,
          _deviceService.getDeviceId(),
          _storageRepository.getShareCount(),
        ).wait;

        if (!hasInternet || deviceId == null) break;

        final share = shareResult is DataSuccess<int>
            ? shareResult.data ?? 0
            : 0;
        await _coinsRemoteSource.setCoins(
          deviceId,
          pending.coins,
          share: share,
          timestamp: pending.timestamp,
        );
      }
    } catch (_) {
    } finally {
      _isCoinsSyncing = false;
      _pendingCoinsSync = null;
    }
  }

  Future<void> syncShareCountAfterChange(int count, int timestamp) async {
    _pendingShareSync = (count: count, timestamp: timestamp);
    if (_isShareSyncing) return;
    _isShareSyncing = true;
    try {
      while (_pendingShareSync != null) {
        final pending = _pendingShareSync!;
        _pendingShareSync = null;

        final (hasInternet, deviceId, coinsResult, coinsTs) = await (
          _connectivityService.hasInternet,
          _deviceService.getDeviceId(),
          _storageRepository.getCoins(),
          _getTimestamp(_storageRepository.getCoinsTimestamp),
        ).wait;

        if (!hasInternet || deviceId == null) break;

        final coins = coinsResult is DataSuccess<int>
            ? coinsResult.data ?? 0
            : 0;
        final ts = pending.timestamp > coinsTs ? pending.timestamp : coinsTs;
        await _coinsRemoteSource.setCoins(
          deviceId,
          coins,
          share: pending.count,
          timestamp: ts,
        );
      }
    } catch (_) {
    } finally {
      _isShareSyncing = false;
      _pendingShareSync = null;
    }
  }

  Future<void> syncCoinsOnAppClose() async {
    try {
      final (deviceId, localCoins, localShare, coinsTs, shareTs) = await (
        _deviceService.getDeviceId(),
        _storageRepository.getCoins(),
        _storageRepository.getShareCount(),
        _getTimestamp(_storageRepository.getCoinsTimestamp),
        _getTimestamp(_storageRepository.getShareCountTimestamp),
      ).wait;

      if (deviceId == null) return;
      if (localCoins case DataSuccess<int>(:final data?)) {
        final share = localShare is DataSuccess<int> ? localShare.data ?? 0 : 0;
        final ts = coinsTs > shareTs ? coinsTs : shareTs;
        if (ts > 0) {
          unawaited(_syncToRemote(deviceId, data, share, ts));
        }
      }
    } catch (_) {}
  }
}
