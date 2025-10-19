import 'package:device_info_plus/device_info_plus.dart';

import '../../src/data/sources/local/storage_service.dart';

class DeviceService {
  DeviceService({required StorageService storageService})
    : _storageService = storageService,
      _deviceIdKey = 'deviceId';

  final StorageService _storageService;
  final String _deviceIdKey;

  Future<String?> getDeviceId() async {
    try {
      final cached = await _storageService.get<String>(_deviceIdKey);
      if (cached != null && cached.isNotEmpty) return cached;

      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final deviceId = androidInfo.id;

      if (deviceId.isNotEmpty) {
        await _storageService.set(_deviceIdKey, deviceId);
        return deviceId;
      }
    } catch (_) {}
    return null;
  }
}
