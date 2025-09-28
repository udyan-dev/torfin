import 'dart:async';

import 'package:torfin/src/data/engine/session.dart';

import '../../../../core/bindings/di.dart';
import '../engine.dart';

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
