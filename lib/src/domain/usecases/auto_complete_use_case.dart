import 'package:dio/dio.dart';

import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
import '../repositories/torrent_repository.dart';

class AutoCompleteUseCase extends BaseUseCase<dynamic, String> {
  AutoCompleteUseCase({required TorrentRepository torrentRepository})
    : _torrentRepository = torrentRepository;

  final TorrentRepository _torrentRepository;

  @override
  Future<DataState<dynamic>> call(
    String params, {
    required CancelToken cancelToken,
  }) async {
    return _torrentRepository.autoComplete(
      search: params,
      cancelToken: cancelToken,
    );
  }
}
