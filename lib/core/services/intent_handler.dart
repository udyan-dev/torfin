import 'dart:async';

import 'package:app_links/app_links.dart';

class IntentHandler {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  final _controller = StreamController<String>.broadcast();
  String? _pendingUri;

  Stream<String> get stream => _controller.stream;
  bool get hasPendingUri => _pendingUri != null;

  Future<void> init() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _pendingUri = initialUri.toString();
      }

      _sub = _appLinks.uriLinkStream.listen((uri) {
        _controller.add(uri.toString());
      });
    } catch (_) {}
  }

  void processPendingUri() {
    if (_pendingUri != null) {
      _controller.add(_pendingUri!);
      _pendingUri = null;
    }
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
