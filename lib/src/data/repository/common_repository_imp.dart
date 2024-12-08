import 'package:torfin/core/helper/app_exception.dart';
import 'package:torfin/core/helper/base_repository.dart';
import 'package:torfin/core/helper/data_state.dart';
import 'package:torfin/src/data/source/remote/api_service/api_service.dart';
import 'package:torfin/src/domain/repository/common_repository.dart';

class CommonRepositoryImp extends BaseApiRepository
    implements CommonRepository {
  final ApiService apiService;

  CommonRepositoryImp({required this.apiService});

  @override
  Future<DataState<String>> getToken() async {
    try {
      return await getStateOf(
          request: () async => await apiService.getApiToken());
    } catch (e) {
      return DataFailed(
          AppException(type: AppExceptionType.unknown, message: e.toString()));
    }
  }
}
