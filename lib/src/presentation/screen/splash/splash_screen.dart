import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torfin/core/helper/data_state.dart';
import 'package:torfin/core/utils/app_assets.dart';
import 'package:torfin/core/utils/app_extensions.dart';
import 'package:torfin/core/utils/app_spacing.dart';
import 'package:torfin/core/utils/app_text.dart';
import 'package:torfin/src/presentation/screen/splash/bloc/splash_bloc.dart';

import '../../../../core/router/dynamic_route.dart';
import '../../../injection.dart';
import '../base/base_screen.dart';
import '../network/bloc/network_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<SplashBloc>()..add(const SplashEvent.getToken()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SplashBloc, SplashState>(
            listenWhen: (_, state) =>
                state.status == DataEnum.success ||
                state.status == DataEnum.failure,
            listener: (context, state) {
              if (state.status == DataEnum.success) {
                DynamicRouteWidget.pushReplace(
                    BaseScreen(key: ValueKey("_base_screen_")));
              }
            },
          ),
          BlocListener<NetworkBloc, NetworkState>(
            listenWhen: (_, state) =>
                state.status == NetworkEnum.online ||
                state.status == NetworkEnum.offline,
            listener: (context, state) {
              if (state.status == NetworkEnum.online) {
                context.read<SplashBloc>().add(const SplashEvent.getToken());
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: context.bg,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.server),
                LinearProgressIndicator(
                  backgroundColor: context.iconInActive,
                  valueColor: AlwaysStoppedAnimation<Color>(context.iconActive),
                ),
                AppSpacing.gapH16,
                AppText.header('Connecting to Server'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
