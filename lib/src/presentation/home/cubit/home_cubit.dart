import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/helpers/base_usecase.dart';
import '../../../../core/helpers/data_state.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/intent_handler.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/models/response/empty_state/empty_state.dart';
import '../../../domain/usecases/get_token_use_case.dart';
import '../../widgets/notification_widget.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetTokenUseCase getTokenUseCase,
    required CancelToken cancelToken,
    required NotificationService notificationService,
    required IntentHandler intentHandler,
    required ConnectivityService connectivity,
  }) : _getTokenUseCase = getTokenUseCase,
       _cancelToken = cancelToken,
       _notificationService = notificationService,
       _intentHandler = intentHandler,
       _connectivity = connectivity,
       super(const HomeState()) {
    _init();
  }

  final GetTokenUseCase _getTokenUseCase;
  final CancelToken _cancelToken;
  final ConnectivityService _connectivity;
  final NotificationService _notificationService;
  final IntentHandler _intentHandler;
  StreamSubscription<String>? _intentSub;

  void _init() {
    _notificationService.start();

    _intentSub = _intentHandler.stream.listen((uri) {
      if (state.status == DataStatus.success) {
        emit(state.copyWith(intentUri: uri));
      }
    });
  }

  Future<void> getToken() async {
    if (!await _connectivity.hasInternet) {
      _emitError(noInternetError, failedToConnectToServer);
      return;
    }

    emit(state.copyWith(status: DataStatus.loading));

    final result = await _getTokenUseCase.call(
      NoParams(),
      cancelToken: _cancelToken,
    );

    result.when(
      success: (_) {
        emit(state.copyWith(status: DataStatus.success));
        if (_intentHandler.hasPendingUri) {
          _intentHandler.processPendingUri();
        }
      },
      failure: (error) => _emitError(error.message, failedToConnectToServer),
    );
  }

  void _emitError(String title, String description) {
    emit(
      state.copyWith(
        status: DataStatus.error,
        emptyState: EmptyState(
          stateIcon: AppAssets.icNoNetwork,
          title: title,
          description: description,
          buttonText: retry,
        ),
      ),
    );
  }

  void checkNotificationPermission() {
    unawaited(
      _notificationService.requestPermission().catchError((_) {
        return false;
      }),
    );
  }

  @override
  Future<void> close() {
    _intentSub?.cancel();
    _cancelToken.cancel();
    _notificationService.stop();
    return super.close();
  }
}
