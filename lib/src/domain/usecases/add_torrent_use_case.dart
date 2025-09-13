import 'package:dio/dio.dart';

import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/utils.dart';
import '../../data/engine/engine.dart';

class AddTorrentUseCase
    extends BaseUseCase<TorrentAddedResponse, AddTorrentUseCaseParams> {
  AddTorrentUseCase({required Engine engine}) : _engine = engine;

  final Engine _engine;

  @override
  Future<DataState<TorrentAddedResponse>> call(
    AddTorrentUseCaseParams params, {
    required CancelToken cancelToken,
  }) async {
    try {
      final downloadDir = await getDownloadDirectory();

      final result = await _engine.addTorrent(
        params.magnetLink,
        null,
        downloadDir,
      );
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        BaseException(
          type: BaseExceptionType.unknown,
          message: 'Failed to add torrent: ${e.toString()}',
        ),
      );
    }
  }
}

class AddTorrentUseCaseParams {
  final String magnetLink;

  const AddTorrentUseCaseParams({required this.magnetLink});
}
