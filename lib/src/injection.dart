import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:torfin/src/presentation/screen/network/bloc/network_bloc.dart';

import '../core/router/dynamic_route.dart';

final di = GetIt.I;
final navigationContext = di<GlobalKey<NavigatorState>>().currentContext!;

Future<void> inject() async {
  di.registerSingleton<GlobalKey<NavigatorState>>(
      DynamicRouteWidget.navigatorKey);
  di.registerSingleton<Connectivity>(Connectivity());
  di.registerSingleton<NetworkBloc>(
      NetworkBloc(networkListener: di<Connectivity>().onConnectivityChanged));
}
