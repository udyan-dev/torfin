import 'package:dio/dio.dart';

import '../../../core/helper/app_exception.dart';
import '../../../core/helper/base_usecase.dart';
import '../../../core/helper/data_state.dart';
import '../../data/model/response/torrent/torrent_res.dart';
import '../repository/storage_repository.dart';

class GetFavoriteUseCase extends BaseUseCase<List<TorrentRes>, NoParams> {
  final StorageRepository storageRepository;

  GetFavoriteUseCase({required this.storageRepository});

  @override
  Future<DataState<List<TorrentRes>>> call(
    NoParams params, {
    CancelToken? cancelToken,
  }) async {
    try {
      return DataSuccess(await storageRepository.getSavedTorrents());
    } on AppException catch (e) {
      return DataFailed(AppException(type: e.type, message: e.message));
    }
  }
}
