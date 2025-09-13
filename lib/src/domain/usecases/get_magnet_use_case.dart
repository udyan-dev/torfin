import 'package:dio/dio.dart';

import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
import '../repositories/torrent_repository.dart';

class GetMagnetUseCase extends BaseUseCase<List<String>, String> {
  GetMagnetUseCase({required TorrentRepository torrentRepository})
    : _torrentRepository = torrentRepository;

  final TorrentRepository _torrentRepository;

  @override
  Future<DataState<List<String>>> call(
    String params, {
    required CancelToken cancelToken,
  }) async {
    return _torrentRepository.getMagnetLinks(
      site: params,
      cancelToken: cancelToken,
    );
  }
}
