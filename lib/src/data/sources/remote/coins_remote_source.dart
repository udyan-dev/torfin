import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/connectivity_service.dart';

class CoinsRemoteSource {
  CoinsRemoteSource({required ConnectivityService connectivityService})
    : _connectivityService = connectivityService;

  final ConnectivityService _connectivityService;

  Future<({int coins, int timestamp})?> getCoinsWithTimestamp(
    String deviceId,
  ) async {
    try {
      if (!await _connectivityService.hasInternet) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(deviceId)
          .get();

      if (!doc.exists) return null;

      final coins = doc.data()?['coins'] as int?;
      final timestamp = doc.data()?['timestamp'] as int?;

      if (coins == null || timestamp == null) return null;

      return (coins: coins, timestamp: timestamp);
    } catch (_) {
      return null;
    }
  }

  Future<bool> setCoins(String deviceId, int coins) async {
    try {
      if (!await _connectivityService.hasInternet) return false;

      await FirebaseFirestore.instance.collection('users').doc(deviceId).set({
        'coins': coins,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }, SetOptions(merge: true));
      return true;
    } catch (_) {
      return false;
    }
  }
}
