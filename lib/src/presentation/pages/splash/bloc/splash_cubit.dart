// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:torfin/core/helper/data_state.dart';

import '../../../../../core/helper/base_cubit.dart';
import '../../../../../core/helper/base_usecase.dart';
import '../../../../domain/usecase/get_token_use_case.dart';

part 'splash_cubit.freezed.dart';
part 'splash_state.dart';

class SplashCubit extends BaseCubit<SplashState> {
  final GetTokenUseCase getTokenUseCase;
  final CancelToken cancelToken;

  SplashCubit({required this.getTokenUseCase, required this.cancelToken})
    : super(const SplashState());

  fetchToken() async {
    emit(state.copyWith(status: SplashEnum.loading));
    final result = await getTokenUseCase.call(
      NoParams(),
      cancelToken: cancelToken,
    );
    if (result is DataSuccess) {
      emit(state.copyWith(status: SplashEnum.success));
    } else {
      emit(state.copyWith(status: SplashEnum.failure));
    }
  }

  @override
  Future<void> closeToken() async {
    cancelToken.cancel();
  }
}
