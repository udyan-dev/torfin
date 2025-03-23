// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/helper/base_cubit.dart';

part 'connectivity_cubit.freezed.dart';
part 'connectivity_state.dart';

class ConnectivityCubit extends BaseCubit<ConnectivityState> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityCubit() : super(const ConnectivityState()) {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      bool isConnected = !result.contains(ConnectivityResult.none);
      _onConnectivityChanged(isConnected);
    });
  }

  void _onConnectivityChanged(bool isConnected) {
    emit(state.copyWith(
      status: isConnected ? ConnectivityEnum.online : ConnectivityEnum.offline,
      changed: state.status !=
          (isConnected ? ConnectivityEnum.online : ConnectivityEnum.offline),
    ));
  }

  @override
  Future<void> closeToken() async {
    _connectivitySubscription.cancel();
  }
}
