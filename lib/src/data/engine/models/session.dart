import 'dart:async';

import 'package:flutter/material.dart';
import 'package:torfin/src/data/engine/session.dart';

import '../../../../core/bindings/di.dart';
import '../engine.dart';

const refreshIntervalSeconds = 1;

class SessionModel extends ChangeNotifier {
  Session? session;

  SessionModel() {
    _startSessionFetching();
  }

  Future fetchSession() async {
    session = await di<Engine>().fetchSession();
    notifyListeners();
  }

  void _startSessionFetching() {
    fetchSession();
    Timer.periodic(const Duration(seconds: refreshIntervalSeconds), (_) => fetchSession());
  }
}
