import 'package:dio/dio.dart';

import '../../../core/helper/app_exception.dart';
import '../../../core/helper/base_usecase.dart';
import '../../../core/helper/data_state.dart';
import '../../data/model/response/torrent/torrent_res.dart';
import '../repository/storage_repository.dart';

class SaveTorrentUseCase extends BaseUseCase<bool, TorrentRes> {
  final StorageRepository storageRepository;

  SaveTorrentUseCase({required this.storageRepository});

  @override
  Future<DataState<bool>> call(
    TorrentRes torrent, {
    CancelToken? cancelToken,
  }) async {
    try {
      final result = await storageRepository.saveTorrent(torrent: torrent);
      if (result) {
        return DataSuccess(result);
      } else {
        return DataFailed(
          AppException(type: AppExceptionType.unknown, message: "error"),
        );
      }
    } on AppException catch (e) {
      return DataFailed(AppException(type: e.type, message: e.message));
    }
  }
}
