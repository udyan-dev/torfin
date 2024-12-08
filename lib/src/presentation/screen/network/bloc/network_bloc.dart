import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/helper/base_bloc.dart';

part 'network_bloc.freezed.dart';
part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends BaseBloc<NetworkEvent, NetworkState> {
  final Stream<List<ConnectivityResult>> networkListener;

  NetworkBloc({required this.networkListener}) : super(const NetworkState()) {
    on<NetworkEvent>((event, emit) async {
      await for (final data in networkListener) {
        await _onData(data, emit);
      }
    });
  }

  Future<void> _onData(
      List<ConnectivityResult> data, Emitter<NetworkState> emit) async {
    if (data.contains(ConnectivityResult.none)) {
      emit(state.copyWith(status: NetworkEnum.offline));
    } else {
      emit(state.copyWith(status: NetworkEnum.online));
    }
  }

  @override
  Future<void> closeToken() async {
    networkListener;
  }
}
