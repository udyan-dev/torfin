import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/bindings/env.dart';
import '../../../../core/helpers/base_exception.dart';
import '../../../../core/utils/string_constants.dart';
import '../../models/response/torrent/torrent_res.dart';

class DioService {
  const DioService({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<List<T>> getCollection<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
  }) {
    log('HTTP_GET: $endpoint');
    return _handleCollectionRequest<List<T>>(
      request: () => _dio.get<String>(
        endpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        options: Options(headers: torrentHeaders),
      ),
    );
  }

  Future<String> getString({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
  }) => _executeRequest<String>(
    request: () => _dio.get<String>(
      endpoint,
      queryParameters: queryParams,
      cancelToken: cancelToken,
      options: Options(headers: torrentHeaders),
    ),
    extractor: (response) => response.data!,
  );

  Future<List<String>> getMagnetLinks({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
  }) => _executeRequest<List<String>>(
    request: () => _dio.get<String>(
      '${Env.proxyUrl}$endpoint',
      queryParameters: queryParams,
      cancelToken: cancelToken,
    ),
    extractor: (response) => _extractMagnetLinks(response.data!),
  );

  Future<T> _handleCollectionRequest<T>({
    required Future<Response<String>> Function() request,
  }) async {
    try {
      final response = await request();
      final result = _deserializeTorrentList(response.data!);
      return result as T;
    } on DioException catch (e) {
      throw BaseException.fromDioError(e);
    } catch (e) {
      throw BaseException(
        type: BaseExceptionType.unknown,
        message: '$getRequestError: ${e.toString()}',
        error: e,
      );
    }
  }

  Future<T> _executeRequest<T>({
    required Future<Response<String>> Function() request,
    required T Function(Response<String>) extractor,
  }) async {
    try {
      final response = await request();
      return extractor(response);
    } on DioException catch (e) {
      throw BaseException.fromDioError(e);
    } catch (e) {
      throw BaseException(
        type: BaseExceptionType.unknown,
        message: '$getRequestError: ${e.toString()}',
        error: e,
      );
    }
  }

  List<TorrentRes> _deserializeTorrentList(String data) {
    if (data.isEmpty) return const <TorrentRes>[];

    try {
      final List<dynamic> jsonData = switch (data) {
        final String jsonString when jsonString.isNotEmpty => jsonDecode(
          jsonString,
        ),
        _ => <dynamic>[],
      };

      if (jsonData.isEmpty) return const <TorrentRes>[];

      final result = <TorrentRes>[];
      int skippedCount = 0;

      for (int i = 0; i < jsonData.length; i++) {
        final item = jsonData[i];
        try {
          if (item is Map<String, dynamic>) {
            result.add(TorrentRes.fromJson(item));
          } else {
            skippedCount++;
          }
        } catch (e) {
          skippedCount++;
          continue;
        }
      }

      log(
        'JSON_PARSE: received=${jsonData.length} parsed=${result.length} skipped=$skippedCount',
      );
      return result;
    } catch (e) {
      throw BaseException(
        type: BaseExceptionType.parseError,
        message: parseDataError,
        error: e,
      );
    }
  }

  List<String> _extractMagnetLinks(String htmlContent) {
    if (htmlContent.isEmpty) return const <String>[];

    try {
      final matches = regexMagnet.allMatches(htmlContent);
      if (matches.isEmpty) return const <String>[];

      return matches
          .map((match) => match.group(0))
          .where((link) => link != null)
          .cast<String>()
          .toList(growable: false);
    } catch (e) {
      throw BaseException(
        type: BaseExceptionType.parseError,
        message: parseDataError,
        error: e,
      );
    }
  }
}
