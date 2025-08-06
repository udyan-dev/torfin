import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/base_usecase.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/string_constants.dart';
import '../../data/models/request/search/search_req.dart';
import '../../data/models/response/torrent/torrent_res.dart';
import '../repositories/storage_repository.dart';
import '../repositories/torrent_repository.dart';

class SearchTorrentUseCase
    extends BaseUseCase<List<TorrentRes>, SearchTorrentUseCaseParams> {
  SearchTorrentUseCase({
    required TorrentRepository torrentRepository,
    required StorageRepository storageRepository,
    required this.uuid,
  }) : _torrentRepository = torrentRepository,
       _storageRepository = storageRepository;

  final TorrentRepository _torrentRepository;
  final StorageRepository _storageRepository;
  final Uuid uuid;

  @override
  Future<DataState<List<TorrentRes>>> call(
    SearchTorrentUseCaseParams params, {
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

      return _torrentRepository.search(
        searchReq: SearchReq(
          token: token,
          uuid: uuid.v4().substring(0, 8),
          sort: params.sort,
          nsfw: values.last.data ?? emptyString,
          search: params.search,
          page: params.page,
        ),
        cancelToken: cancelToken,
      );
    });
  }
}

class SearchTorrentUseCaseParams {
  final String sort;
  final String search;
  final int page;

  const SearchTorrentUseCaseParams({
    required this.sort,
    required this.search,
    required this.page,
  });
}
