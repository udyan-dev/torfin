import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:torfin/core/theme/app_styles.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/src/presentation/screen/base/base_screen.dart';
import 'package:torfin/src/presentation/screen/network/bloc/network_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../injection.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  OverlayEntry? _overlayEntry;

  final _overlay = OverlayEntry(
      builder: (_) => Positioned.fill(
              child: Scaffold(
                  body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AppAssets.network),
                Text(AppStrings.noNetwork, style: AppStyles.styleOne)
              ],
            ),
          ))));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => di<NetworkBloc>()..add(NetworkEvent()),
        child: Scaffold(
          body: BlocListener<NetworkBloc, NetworkState>(
            listenWhen: (_, state) =>
                state.status == NetworkEnum.offline ||
                state.status == NetworkEnum.online,
            listener: (_, state) {
              if (state.status == NetworkEnum.online) {
                if (_overlayEntry?.mounted == true) {
                  _overlayEntry?.remove();
                }
              } else if (state.status == NetworkEnum.offline) {
                _overlayEntry = _overlay;
                Overlay.of(context).insert(_overlayEntry!);
              }
            },
            child: BaseScreen(),
          ),
        ));
  }
}
