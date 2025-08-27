import '../../src/data/models/request/search/search_req.dart';
import '../../src/data/models/request/trending/trending_req.dart';
import '../bindings/env.dart';

sealed class Routes {
  static String search({required SearchReq searchReq}) =>
      '${Env.baseUrl}${searchReq.token}/${searchReq.search}/${searchReq.uuid}/${searchReq.page}/${searchReq.sort}/NONE/${searchReq.nsfw}';

  static String autoComplete({required String search}) =>
      '${Env.autoCompleteUrl}${Uri.encodeQueryComponent(search)}';

  static String trending({required TrendingReq trendingReq}) =>
      "${Env.baseUrl}${trendingReq.token}/Q/${trendingReq.uuid}/0/${trendingReq.sort}/${trendingReq.top}/${trendingReq.nsfw}";
}
