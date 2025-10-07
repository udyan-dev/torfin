import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/helpers/base_usecase.dart';
import '../../../../core/helpers/data_state.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../../core/utils/utils.dart';
import '../../shared/notification_builders.dart';
import '../../../data/models/response/empty_state/empty_state.dart';
import '../../../domain/usecases/get_token_use_case.dart';
import '../../widgets/notification_widget.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTokenUseCase _getTokenUseCase;
  final CancelToken _cancelToken;
  final ConnectivityService _connectivity;
  final NotificationService _notificationService;

  HomeCubit({
    required GetTokenUseCase getTokenUseCase,
    required CancelToken cancelToken,
    required NotificationService notificationService,
    ConnectivityService? connectivity,
  }) : _getTokenUseCase = getTokenUseCase,
       _cancelToken = cancelToken,
       _notificationService = notificationService,
       _connectivity = connectivity ?? ConnectivityService(),
       super(const HomeState()) {
    _notificationService.start();
  }

  Future<void> getToken() async {
    if (!await _connectivity.hasInternet) {
      emit(
        state.copyWith(
          status: DataStatus.error,
          emptyState: const EmptyState(
            stateIcon: AppAssets.icNoNetwork,
            title: noInternetError,
            description: failedToConnectToServer,
            buttonText: retry,
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(status: DataStatus.loading));

    await _getTokenUseCase
        .call(NoParams(), cancelToken: _cancelToken)
        .then(
          (response) => response.when(
            success: (token) =>
                emit(state.copyWith(status: DataStatus.success)),
            failure: (error) => emit(
              state.copyWith(
                status: DataStatus.error,
                emptyState: EmptyState(
                  stateIcon: AppAssets.icNoNetwork,
                  title: error.message,
                  description: failedToConnectToServer,
                  buttonText: retry,
                ),
              ),
            ),
          ),
        );
  }

  Future<void> checkNotificationPermission() async {
    try {
      await _notificationService.requestPermission();
    } catch (_) {}
  }

  Future<void> checkDownloadPermission() async {
    try {
      final sdk = await getAndroidSdkVersion();
      if (sdk <= 29) {
        if (!await Permission.storage.isGranted &&
            await Permission.storage.request() != PermissionStatus.granted) {
          emit(
            state.copyWith(
              notification: errorNotification(
                storagePermissionNotGranted,
                pleaseGrantStoragePermission,
              ),
            ),
          );
        }
      }
    } catch (_) {
      emit(
        state.copyWith(
          notification: errorNotification(
            storagePermissionNotGranted,
            somethingWentWrong,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _cancelToken.cancel();
    _notificationService.stop();
    return super.close();
  }
}
