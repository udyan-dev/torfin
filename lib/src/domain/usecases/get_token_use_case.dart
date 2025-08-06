import 'package:dio/dio.dart';

import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
import '../repositories/storage_repository.dart';
import '../repositories/torrent_repository.dart';

class GetTokenUseCase extends BaseUseCase<void, NoParams> {
  GetTokenUseCase({
    required TorrentRepository torrentRepository,
    required StorageRepository storageRepository,
  }) : _torrentRepository = torrentRepository,
       _storageRepository = storageRepository;

  final TorrentRepository _torrentRepository;
  final StorageRepository _storageRepository;

  @override
  Future<DataState<void>> call(
    NoParams params, {
    required CancelToken cancelToken,
  }) async {
    return _torrentRepository
        .getToken(cancelToken: cancelToken)
        .then(
          (response) => response.when(
            success: (token) => _storageRepository.setToken(token),
          ),
        );
  }
}
