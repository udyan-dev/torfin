import 'dart:async';

import '../../../../core/bindings/di.dart';
import '../engine.dart';
import '../session.dart';

class SessionService {
  Session? session;
  Timer? _timer;

  Future<Session> fetchSession() async {
    session = await di<Engine>().fetchSession();
    return session!;
  }

  void startPeriodicFetch() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => fetchSession());
  }

  void stopPeriodicFetch() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stopPeriodicFetch();
  }
}
