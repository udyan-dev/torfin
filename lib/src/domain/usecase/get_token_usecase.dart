import 'package:dio/dio.dart';
import 'package:torfin/core/helper/app_exception.dart';
import 'package:torfin/src/domain/repository/common_repository.dart';
import 'package:torfin/src/domain/repository/storage_repository.dart';

import '../../../core/helper/base_usecase.dart';
import '../../../core/helper/data_state.dart';

class GetTokenUseCase extends BaseUseCase<String, NoParams> {
  final CommonRepository commonRepository;
  final StorageRepository storageRepository;

  GetTokenUseCase({
    required this.commonRepository,
    required this.storageRepository,
  });

  @override
  Future<DataState<String>> call(NoParams params,
      [CancelToken? cancelToken]) async {
    try {
      final response = await commonRepository.getToken();
      if (isSuccess(response)) {
        final token = response.data ?? "";
        if (token.isNotEmpty) {
          await storageRepository.setToken(token: token);
          return response;
        }
        return DataFailed(AppException(
            type: AppExceptionType.unknown, message: "TOKEN_EMPTY"));
      }
      return response;
    } catch (e) {
      return DataFailed(
          AppException(type: AppExceptionType.unknown, message: e.toString()));
    }
  }
}
