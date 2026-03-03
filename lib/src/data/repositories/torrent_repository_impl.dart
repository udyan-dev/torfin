import 'package:dio/dio.dart';

import '../../../core/bindings/env.dart';
import '../../../core/helpers/base_exception.dart';
import '../../../core/helpers/base_repository.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/routes.dart';
import '../../../core/utils/string_constants.dart';
import '../../domain/repositories/torrent_repository.dart';
import '../models/request/search/search_req.dart';
import '../models/request/trending/trending_req.dart';
import '../models/response/torrent/torrent_res.dart';
import '../sources/remote/dio_service.dart';

class TorrentRepositoryImpl extends BaseRepository
    implements TorrentRepository {
  TorrentRepositoryImpl({required DioService dioService})
    : _dioService = dioService;

  final DioService _dioService;
  String? _cachedToken;

  @override
  Future<DataState<String>> getToken({required CancelToken cancelToken}) =>
      getStateOf(
        request: () async {
          if (_cachedToken != null) return _cachedToken!;

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

          _cachedToken = token;
          return token;
        },
      );

  Future<String> _fetchApiKey(CancelToken cancelToken) async {
    try {
      final data = await _dioService.getString(
        endpoint: Env.baseUrl,
        cancelToken: cancelToken,
      );
      return regexForJs.firstMatch(data)?.group(0) ?? emptyString;
    } catch (e) {
      throw e is BaseException
          ? e
          : BaseException(
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
      return regexForKey.firstMatch(data)?.group(1) ?? emptyString;
    } catch (e) {
      throw e is BaseException
          ? e
          : BaseException(
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
    request: () => _dioService.getCollection<TorrentRes>(
      endpoint: Routes.search(searchReq: searchReq),
      queryParams: queryTimeStamp,
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<DataState<String>> autoComplete({
    required String search,
    required CancelToken cancelToken,
  }) => getStateOf(
    request: () => _dioService.getString(
      endpoint: Routes.autoComplete(search: search),
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<DataState<List<TorrentRes>>> trending({
    required TrendingReq trendingReq,
    required CancelToken cancelToken,
  }) => getStateOf(
    request: () => _dioService.getCollection<TorrentRes>(
      endpoint: Routes.trending(trendingReq: trendingReq),
      queryParams: queryTimeStamp,
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<DataState<List<String>>> getMagnetLinks({
    required String site,
    required CancelToken cancelToken,
  }) => getStateOf(
    request: () =>
        _dioService.getMagnetLinks(endpoint: site, cancelToken: cancelToken),
  );
}
