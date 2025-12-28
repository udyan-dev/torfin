import 'dart:async';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

sealed class ConsentService {
  static bool _initialized = false;
  static bool _canRequestAds = false;

  static bool get canRequestAds => _canRequestAds;

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    if (!Platform.isAndroid && !Platform.isIOS) {
      _canRequestAds = true;
      return;
    }

    try {
      await _requestConsentInfoUpdate(ConsentRequestParameters());
    } catch (_) {
      _canRequestAds = true;
    }
  }

  static Future<void> _requestConsentInfoUpdate(
    ConsentRequestParameters params,
  ) async {
    final completer = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        await _loadAndShowFormIfRequired();
        _canRequestAds = await ConsentInformation.instance.canRequestAds();
        completer.complete();
      },
      (error) {
        _canRequestAds = true;
        completer.complete();
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        _canRequestAds = true;
      },
    );
  }

  static Future<void> _loadAndShowFormIfRequired() async {
    if (await ConsentInformation.instance.isConsentFormAvailable()) {
      final completer = Completer<void>();
      ConsentForm.loadAndShowConsentFormIfRequired((_) => completer.complete());
      await completer.future;
    }
  }
}
