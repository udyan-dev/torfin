import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:torfin/core/helper/base_usecase.dart';
import 'package:torfin/src/domain/usecase/get_token_usecase.dart';

import '../../../../../core/helper/base_bloc.dart';
import '../../../../../core/helper/data_state.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
  final GetTokenUseCase getTokenUseCase;
  final CancelToken cancelToken;

  SplashBloc({
    required this.getTokenUseCase,
    required this.cancelToken,
  }) : super(const SplashState()) {
    on<_GetToken>((event, emit) async {
      emit(state.copyWith(status: DataEnum.loading));
      final response = await getTokenUseCase.call(NoParams());
      if (isSuccess(response)) {
        emit(state.copyWith(status: DataEnum.success));
      } else {
        emit(state.copyWith(status: DataEnum.failure));
      }
    });
  }

  @override
  Future<void> closeToken() async {
    cancelToken.cancel();
  }
}
