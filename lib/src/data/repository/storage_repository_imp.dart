import 'package:torfin/core/helper/app_exception.dart';
import 'package:torfin/core/utils/app_constants.dart';
import 'package:torfin/src/data/source/local/storage_service.dart';
import 'package:torfin/src/domain/repository/storage_repository.dart';

class StorageRepositoryImp implements StorageRepository {
  final StorageService storageService;

  StorageRepositoryImp({required this.storageService});

  @override
  String getToken() {
    try {
      return storageService.getCommon(AppConstants.keyToken) ?? "";
    } catch (e) {
      throw AppException(type: AppExceptionType.unknown, message: e.toString());
    }
  }

  @override
  Future<bool> setToken({required String token}) async {
    return await storageService.setCommon(AppConstants.keyToken, token);
  }
}
