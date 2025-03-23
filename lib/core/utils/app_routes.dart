import 'package:torfin/src/data/model/request/search/search_req.dart';
import 'package:torfin/src/env.dart';

import '../../src/data/model/request/trending/trending_req.dart';

sealed class AppRoutes {
  static getTrending({required TrendingReq trendingReq}) =>
      "/${trendingReq.token}/Q/${trendingReq.uuid}/0/${trendingReq.sort}/${trendingReq.top}/${trendingReq.nsfw}";

  static search({required SearchReq searchReq}) =>
      "/${searchReq.token}/${searchReq.search}/${searchReq.uuid}/${searchReq.page}/${searchReq.sort}/NONE/${searchReq.nsfw}";

  static autoComplete({required String search}) =>
      "${Env.autoCompleteUrl}$search";
}
