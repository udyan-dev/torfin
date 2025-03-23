import 'package:dio/dio.dart';
import 'package:torfin/src/data/model/request/search/search_req.dart';
import 'package:uuid/uuid.dart';

import '../../../core/helper/app_exception.dart';
import '../../../core/helper/base_usecase.dart';
import '../../../core/helper/data_state.dart';
import '../../data/model/response/torrent/torrent_res.dart';
import '../repository/torfin_repository.dart';
import '../repository/storage_repository.dart';

class SearchTorrentUseCase
    extends BaseUseCase<List<TorrentRes>, SearchTorrentUseCaseParams> {
  final TorfinRepository torfinRepository;
  final StorageRepository storageRepository;

  SearchTorrentUseCase({
    required this.torfinRepository,
    required this.storageRepository,
  });

  final _uuid = const Uuid();

  @override
  Future<DataState<List<TorrentRes>>> call(
    SearchTorrentUseCaseParams params, {
    required CancelToken cancelToken,
  }) async {
    try {
      final data = await Future.wait([
        storageRepository.getToken(),
        storageRepository.getNsfw(),
      ]);
      final uuid = _uuid.v4().substring(0, 8);
      final searchReq = SearchReq(
        token: data.first,
        uuid: uuid,
        sort: params.sort,
        nsfw: data.last,
        search: params.search,
        page: params.page,
      );
      return torfinRepository.searchTorrent(
        searchReq: searchReq,
        cancelToken: cancelToken,
      );
    } on AppException catch (e) {
      return DataFailed(AppException(type: e.type, message: e.message));
    }
  }
}

class SearchTorrentUseCaseParams {
  final String sort;
  final String search;
  final int page;

  SearchTorrentUseCaseParams({
    required this.sort,
    required this.search,
    required this.page,
  });
}
