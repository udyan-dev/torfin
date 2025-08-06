import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/helpers/base_usecase.dart';
import '../../../../core/helpers/data_state.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/models/response/empty_state/empty_state.dart';
import '../../../domain/usecases/get_token_use_case.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTokenUseCase _getTokenUseCase;
  final CancelToken _cancelToken;
  final ConnectivityService _connectivity;

  HomeCubit({
    required GetTokenUseCase getTokenUseCase,
    required CancelToken cancelToken,
    ConnectivityService? connectivity,
  }) : _getTokenUseCase = getTokenUseCase,
       _cancelToken = cancelToken,
       _connectivity = connectivity ?? ConnectivityService(),
       super(const HomeState());

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

  @override
  Future<void> close() async {
    _cancelToken.cancel();
    return super.close();
  }
}
