import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/core/route/animate_route.dart';
import 'package:torfin/core/utils/app_extension.dart';
import 'package:torfin/gen/assets.gen.dart';
import 'package:torfin/src/injection.dart';
import 'package:torfin/src/presentation/pages/home/home_page.dart';
import 'package:torfin/src/presentation/widgets/connectivity/bloc/connectivity_cubit.dart';

import '../../../../core/theme/app_text.dart';
import '../../../../core/utils/app_constant.dart';
import '../../widgets/icon_widget.dart';
import '../home/bloc/home_cubit.dart';
import 'bloc/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<SplashCubit>()..fetchToken(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SplashCubit, SplashState>(
            listenWhen:
                (p, c) =>
                    c.status == SplashEnum.success ||
                    c.status == SplashEnum.failure,
            listener: (context, state) {
              if (state.status == SplashEnum.success) {
                AnimateRoute.pushReplace(
                  BlocProvider(
                    create:
                        (context) =>
                            di<HomeCubit>()
                              ..initialize()
                              ..getAllFavorites(),
                    child: const HomePage(),
                  ),
                );
              }
            },
          ),
          BlocListener<ConnectivityCubit, ConnectivityState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == ConnectivityEnum.online && state.changed) {
                context.read<SplashCubit>().fetchToken();
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: context.themeColors.background,
          body: BlocBuilder<SplashCubit, SplashState>(
            buildWhen:
                (p, c) =>
                    c.status == SplashEnum.loading ||
                    c.status == SplashEnum.success ||
                    c.status == SplashEnum.failure,
            builder: (context, state) {
              if (state.status == SplashEnum.failure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      SvgPicture.asset(
                        AppAsset.svg.icWarning.path,
                        colorFilter:
                            context.themeColors.iconPrimary.colorFilter,
                        width: 128,
                        height: 128,
                      ),
                      AppText.heading03(
                        AppConstant.serverNotReachable,
                        textAlign: TextAlign.center,
                      ),
                      IconWidget(
                        icon: AppAsset.svg.icRefresh,
                        onTap: () => context.read<SplashCubit>().fetchToken(),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  AppText.heading03(
                    AppConstant.connectingToServer,
                    color: context.themeColors.textSecondary,
                  ),
                  AppConstant.circularProgress,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
