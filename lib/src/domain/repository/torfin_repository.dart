import 'package:dio/dio.dart';
import 'package:torfin/core/helper/data_state.dart';

import '../../data/model/request/search/search_req.dart';
import '../../data/model/request/trending/trending_req.dart';
import '../../data/model/response/torrent/torrent_res.dart';

abstract class TorfinRepository {
  Future<DataState<List<TorrentRes>>> getTrending({
    required TrendingReq trendingReq,
    required CancelToken cancelToken,
  });

  Future<DataState<List<TorrentRes>>> searchTorrent({
    required SearchReq searchReq,
    required CancelToken cancelToken,
  });

  Future<DataState<List<String>>> magnet({
    required String site,
    required CancelToken cancelToken,
  });

  Future<DataState<dynamic>> autoComplete({
    required String search,
    required CancelToken cancelToken,
  });
}
