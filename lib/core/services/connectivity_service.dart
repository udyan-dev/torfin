import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<bool> get hasInternet async {
    final List<ConnectivityResult> r = await Connectivity().checkConnectivity();
    for (int i = 0; i < r.length; i++) {
      if (r[i] != ConnectivityResult.none) return true;
    }
    return false;
  }
}
