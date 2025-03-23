import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/route/animate_route.dart';
import 'core/service/foreground_service.dart';
import 'core/theme/app_theme.dart';
import 'src/injection.dart';
import 'src/presentation/pages/splash/splash_page.dart';
import 'src/presentation/widgets/banner_widget.dart';
import 'src/presentation/widgets/blur_widget.dart';
import 'src/presentation/widgets/connectivity/bloc/connectivity_cubit.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
bool _isBannerActive = false;

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setup();
    await createForegroundService();
    runApp(const MyApp());
  }, _handleError);
}

void _handleError(e, s) {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => di<ConnectivityCubit>())],
      child: BlocListener<ConnectivityCubit, ConnectivityState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.changed) {
            _toggleConnectionState(state.status);
          }
        },
        child: MaterialApp(
          title: 'Torfin',
          navigatorKey: AnimateRoute.navigatorKey,
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: (context, child) {
            return SafeArea(
              bottom: false,
              child: Stack(
                children: [if (child != null) child, const BlurWidget()],
              ),
            );
          },
          home: const SplashPage(),
        ),
      ),
    );
  }

  void _toggleConnectionState(ConnectivityEnum status) {
    if (_isBannerActive) {
      scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
      _isBannerActive = false;
    }
    if (status == ConnectivityEnum.offline && !_isBannerActive) {
      scaffoldMessengerKey.currentState?.showMaterialBanner(
        BannerWidget(key: const ValueKey("NETWORK_BANNER")),
      );
      _isBannerActive = true;
    }
  }
}
