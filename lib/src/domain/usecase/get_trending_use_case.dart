import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../core/helper/app_exception.dart';
import '../../../core/helper/base_usecase.dart';
import '../../../core/helper/data_state.dart';
import '../../data/model/request/trending/trending_req.dart';
import '../../data/model/response/torrent/torrent_res.dart';
import '../repository/torfin_repository.dart';
import '../repository/storage_repository.dart';

class GetTrendingUseCase
    extends BaseUseCase<List<TorrentRes>, GetTrendingUseCaseParams> {
  final TorfinRepository torfinRepository;
  final StorageRepository storageRepository;

  GetTrendingUseCase({
    required this.torfinRepository,
    required this.storageRepository,
  });

  final _uuid = const Uuid();

  @override
  Future<DataState<List<TorrentRes>>> call(
    GetTrendingUseCaseParams params, {
    required CancelToken cancelToken,
  }) async {
    try {
      final data = await Future.wait([
        storageRepository.getToken(),
        storageRepository.getNsfw(),
      ]);
      final uuid = _uuid.v4().substring(0, 8);
      final trendingReq = TrendingReq(
        token: data.first,
        uuid: uuid,
        sort: params.sort,
        top: params.top,
        nsfw: data.last,
      );
      return torfinRepository.getTrending(
        trendingReq: trendingReq,
        cancelToken: cancelToken,
      );
    } on AppException catch (e) {
      return DataFailed(AppException(type: e.type, message: e.message));
    }
  }
}

class GetTrendingUseCaseParams {
  final String top;
  final String sort;

  GetTrendingUseCaseParams({required this.top, required this.sort});
}
