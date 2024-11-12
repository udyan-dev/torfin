import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:torfin/src/presentation/screen/network/bloc/network_bloc.dart';

final di = GetIt.I;

Future<void> inject() async {
  di.registerSingleton<Connectivity>(Connectivity());
  di.registerSingleton<NetworkBloc>(
      NetworkBloc(networkListener: di<Connectivity>().onConnectivityChanged));
}
