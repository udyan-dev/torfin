import 'package:dio/dio.dart';
import 'package:torfin/core/helper/app_exception.dart';
import 'package:torfin/core/helper/data_state.dart';
import 'package:torfin/src/data/source/remote/token_service.dart';
import 'package:torfin/src/domain/repository/storage_repository.dart';

import '../../../core/helper/base_usecase.dart';

class GetTokenUseCase extends BaseUseCase<bool, NoParams> {
  final StorageRepository storageRepository;
  final TokenService tokenService;

  GetTokenUseCase({
    required this.storageRepository,
    required this.tokenService,
  });

  @override
  Future<DataState<bool>> call(
    NoParams params, {
    required CancelToken cancelToken,
  }) async {
    try {
      final token = await tokenService.getApiToken();
      if (token.isEmpty) {
        return DataFailed(
          const AppException(
            type: AppExceptionType.unknown,
            message: "No Token Found",
          ),
        );
      }
      await storageRepository.setToken(token: token);
      return DataSuccess(true);
    } on AppException catch (e) {
      return DataFailed(e);
    }
  }
}
