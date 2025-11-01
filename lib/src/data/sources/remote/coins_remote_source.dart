import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/connectivity_service.dart';

class CoinsRemoteSource {
  CoinsRemoteSource({required ConnectivityService connectivityService})
    : _connectivityService = connectivityService;

  final ConnectivityService _connectivityService;

  Future<({int coins, int timestamp, int share, int shareTimestamp})?>
  getCoinsWithTimestamp(String deviceId) async {
    try {
      if (!await _connectivityService.hasInternet) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(deviceId)
          .get();

      if (!doc.exists) return null;

      final coins = doc.data()?['coins'] as int?;
      final timestamp = doc.data()?['timestamp'] as int?;
      final share = doc.data()?['share'] as int? ?? 0;
      final shareTimestamp = doc.data()?['shareTimestamp'] as int? ?? 0;

      if (coins == null || timestamp == null) return null;

      return (
        coins: coins,
        timestamp: timestamp,
        share: share,
        shareTimestamp: shareTimestamp,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> setCoins(String deviceId, int coins, {int? share}) async {
    try {
      if (!await _connectivityService.hasInternet) return false;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(deviceId);

        final snapshot = await transaction.get(docRef);
        final remoteTimestamp = snapshot.data()?['timestamp'] as int? ?? 0;
        final localTimestamp = DateTime.now().millisecondsSinceEpoch;

        if (localTimestamp > remoteTimestamp) {
          final data = <String, dynamic>{
            'coins': coins,
            'timestamp': localTimestamp,
          };

          if (share != null) {
            data['share'] = share;
            data['shareTimestamp'] = localTimestamp;
          }

          transaction.set(docRef, data, SetOptions(merge: true));
        }
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
