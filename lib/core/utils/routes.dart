import '../../src/data/models/request/search/search_req.dart';
import '../bindings/env.dart';

sealed class Routes {
  static String search({required SearchReq searchReq}) =>
      '${Env.baseUrl}${searchReq.token}/${searchReq.search}/${searchReq.uuid}/${searchReq.page}/${searchReq.sort}/NONE/${searchReq.nsfw}';

  static String autoComplete({required String search}) =>
      '${Env.autoCompleteUrl}${Uri.encodeQueryComponent(search)}';
}
