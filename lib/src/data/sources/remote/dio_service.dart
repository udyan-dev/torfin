import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
  }) async {
    try {
      final response = await _dio.get<String>(
        endpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        options: Options(headers: torrentHeaders),
      );

      return await compute(_deserializeTorrentList, response.data ?? '')
          as List<T>;
    } on DioException catch (e) {
      throw BaseException.fromDioError(e);
    } catch (e) {
      throw _handleUnknownError(e);
    }
  }

  Future<String> getString({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<String>(
        endpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        options: Options(headers: torrentHeaders),
      );
      return response.data ?? emptyString;
    } on DioException catch (e) {
      throw BaseException.fromDioError(e);
    } catch (e) {
      throw _handleUnknownError(e);
    }
  }

  Future<List<String>> getMagnetLinks({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<String>(
        '${Env.proxyUrl}$endpoint',
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );

      return await compute(_extractMagnetLinks, response.data ?? '');
    } on DioException catch (e) {
      throw BaseException.fromDioError(e);
    } catch (e) {
      throw _handleUnknownError(e);
    }
  }

  BaseException _handleUnknownError(dynamic e) {
    return BaseException(
      type: BaseExceptionType.unknown,
      message: '$getRequestError: ${e.toString()}',
      error: e,
    );
  }
}

List<TorrentRes> _deserializeTorrentList(String data) {
  if (data.isEmpty) return const [];
  try {
    final List<dynamic> jsonData = jsonDecode(data);
    return jsonData
        .whereType<Map<String, dynamic>>()
        .map((e) => TorrentRes.fromJson(e))
        .toList();
  } catch (e) {
    throw BaseException(
      type: BaseExceptionType.parseError,
      message: parseDataError,
      error: e,
    );
  }
}

List<String> _extractMagnetLinks(String htmlContent) {
  if (htmlContent.isEmpty) return const [];
  try {
    return regexMagnet
        .allMatches(htmlContent)
        .map((m) => m.group(0))
        .whereType<String>()
        .toList();
  } catch (e) {
    throw BaseException(
      type: BaseExceptionType.parseError,
      message: parseDataError,
      error: e,
    );
  }
}
