import 'package:flutter/material.dart';

import 'loading_widget.dart';

typedef FetchingMagnetKeyFn = String? Function();

class MagnetLoadingIndicator extends StatelessWidget {
  final String torrentIdentityKey;
  final FetchingMagnetKeyFn fetchingMagnetKey;

  const MagnetLoadingIndicator({
    super.key,
    required this.torrentIdentityKey,
    required this.fetchingMagnetKey,
  });

  @override
  Widget build(BuildContext context) {
    return fetchingMagnetKey() == torrentIdentityKey
        ? const LoadingWidget()
        : const SizedBox.shrink();
  }
}
