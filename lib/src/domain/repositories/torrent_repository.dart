import 'package:dio/dio.dart';

import '../../../core/helpers/data_state.dart';
import '../../data/models/request/search/search_req.dart';
import '../../data/models/request/trending/trending_req.dart';
import '../../data/models/response/torrent/torrent_res.dart';

abstract class TorrentRepository {
  Future<DataState<String>> getToken({required CancelToken cancelToken});

  Future<DataState<List<TorrentRes>>> search({
    required SearchReq searchReq,
    required CancelToken cancelToken,
  });

  Future<DataState<dynamic>> autoComplete({
    required String search,
    required CancelToken cancelToken,
  });

  Future<DataState<List<TorrentRes>>> trending({
    required TrendingReq trendingReq,
    required CancelToken cancelToken,
  });
}
