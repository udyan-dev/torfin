import 'package:dio/dio.dart';

import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/request/trending/trending_req.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import '../repositories/storage_repository.dart';
import '../repositories/torrent_repository.dart';

class TrendingTorrentUseCase
    extends BaseUseCase<List<TorrentRes>, TrendingTorrentUseCaseParams> {
  TrendingTorrentUseCase({
    required TorrentRepository torrentRepository,
    required StorageRepository storageRepository,
  }) : _torrentRepository = torrentRepository,
       _storageRepository = storageRepository;

  final TorrentRepository _torrentRepository;
  final StorageRepository _storageRepository;

  @override
  Future<DataState<List<TorrentRes>>> call(
    TrendingTorrentUseCaseParams params, {
    required CancelToken cancelToken,
  }) {
    return Future.wait([
      _storageRepository.getToken(),
      _storageRepository.getNsfw(),
    ]).then((values) {
      final token = values.first.data ?? emptyString;
      if (token.isEmpty) {
        return const DataFailed<List<TorrentRes>>(
          BaseException(
            type: BaseExceptionType.parseError,
            message: getTokenError,
          ),
        );
      }

      return _torrentRepository.trending(
        trendingReq: TrendingReq(
          token: token,
          uuid: uuid.v4().substring(0, 8),
          sort: params.sort,
          top: params.top,
          nsfw: values.last.data ?? emptyString,
        ),
        cancelToken: cancelToken,
      );
    });
  }
}

class TrendingTorrentUseCaseParams {
  final String sort;
  final String top;
  final String nsfw;

  const TrendingTorrentUseCaseParams({
    required this.sort,
    required this.top,
    required this.nsfw,
  });
}
