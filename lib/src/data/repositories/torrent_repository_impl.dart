import 'package:dio/dio.dart';
import 'package:torfin/src/data/models/request/search/search_req.dart';
import 'package:torfin/src/data/models/request/trending/trending_req.dart';
import 'package:torfin/src/data/models/response/torrent/torrent_res.dart';

import '../../../core/bindings/env.dart';
import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/base_repository.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/routes.dart';
import '../../../core/utils/string_constants.dart';
import '../../domain/repositories/torrent_repository.dart';
import '../sources/remote/dio_service.dart';

class TorrentRepositoryImpl extends BaseRepository
    implements TorrentRepository {
  TorrentRepositoryImpl({required DioService dioService})
    : _dioService = dioService;

  final DioService _dioService;

  @override
  Future<DataState<String>> getToken({required CancelToken cancelToken}) =>
      getStateOf(
        request: () async {
          final apiKey = await _fetchApiKey(cancelToken);
          if (apiKey.isEmpty) {
            throw const BaseException(
              type: BaseExceptionType.parseError,
              message: apiKeyExtractionError,
            );
          }

          final token = await _fetchToken(apiKey, cancelToken);
          if (token.isEmpty) {
            throw const BaseException(
              type: BaseExceptionType.parseError,
              message: tokenExtractionError,
            );
          }

          return token;
        },
      );

  Future<String> _fetchApiKey(CancelToken cancelToken) async {
    try {
      final data = await _dioService.getString(
        endpoint: Env.baseUrl,
        cancelToken: cancelToken,
      );
      final match = regexForJs.firstMatch(data);
      return match?.group(0) ?? emptyString;
    } on BaseException {
      rethrow;
    } catch (e) {
      throw BaseException(
        type: BaseExceptionType.unknown,
        message: apiKeyFetchError,
        error: e,
      );
    }
  }

  Future<String> _fetchToken(String apiKey, CancelToken cancelToken) async {
    try {
      final data = await _dioService.getString(
        endpoint: '${Env.baseUrl}$apiKey',
        cancelToken: cancelToken,
      );
      final match = regexForKey.firstMatch(data);
      return match?.group(1) ?? emptyString;
    } on BaseException {
      rethrow;
    } catch (e) {
      throw BaseException(
        type: BaseExceptionType.unknown,
        message: tokenFetchError,
        error: e,
      );
    }
  }

  @override
  Future<DataState<List<TorrentRes>>> search({
    required SearchReq searchReq,
    required CancelToken cancelToken,
  }) => getStateOf(
    request: () async => await _dioService.getCollection<TorrentRes>(
      endpoint: Routes.search(searchReq: searchReq),
      queryParams: queryTimeStamp,
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<DataState> autoComplete({
    required String search,
    required CancelToken cancelToken,
  }) => getStateOf(
    request: () async => await _dioService.getString(
      endpoint: Routes.autoComplete(search: search),
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<DataState<List<TorrentRes>>> trending({
    required TrendingReq trendingReq,
    required CancelToken cancelToken,
  }) => getStateOf(
    request: () async => await _dioService.getCollection<TorrentRes>(
      endpoint: Routes.trending(trendingReq: trendingReq),
      queryParams: queryTimeStamp,
      cancelToken: cancelToken,
    ),
  );
}
