import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:torfin/core/helper/app_exception.dart';
import 'package:torfin/src/env.dart';

import '../../../../core/utils/app_constant.dart';
import '../../model/response/torrent/torrent_res.dart';

class DioService {
  final Dio _dio;

  DioService({required Dio dioClient}) : _dio = dioClient;

  Dio get dio => _dio;

  final Options defaultOptions = Options(
    headers: {
      'user-agent':
          "Mozilla/5.0 (Linux; Android ${Platform.operatingSystemVersion})",
      'accept': 'application/json, text/javascript, */*; q=0.01',
      'accept-language': 'en-US,en;q=0.9,en-IN;q=0.8',
      'dnt': '1',
      'priority': 'u=1, i',
      'referer': Env.baseUrl,
      'sec-ch-ua': '"Not(A:Brand";v="99", "Chromium";v="133")',
      'sec-ch-ua-mobile': '?1',
      'sec-ch-ua-platform': '"Android"',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'same-origin',
      'x-requested-with': 'XMLHttpRequest',
    },
  );

  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _handleRequest<T>(
      request:
          () => _dio.get(
            endpoint,
            queryParameters: queryParams,
            options: defaultOptions,
            cancelToken: cancelToken,
          ),
    );
  }

  Future<List<T>> getCollection<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _handleRequest<List<T>>(
      request:
          () => _dio.get<String>(
            endpoint,
            queryParameters: queryParams,
            options: defaultOptions,
            cancelToken: cancelToken,
          ),
    );
  }

  Future<String> autoComplete({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio
          .clone(options: AppConstant.baseOptions)
          .get<String>(
            endpoint,
            queryParameters: queryParams,
            options: defaultOptions,
            cancelToken: cancelToken,
          );
      return response.data!;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: "Error during autocomplete request",
        error: e,
      );
    }
  }

  Future<List<String>> getMagnetLinks({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
  }) async {
    try {
      final workerUrl = '${Env.proxyUrl}$endpoint';

      final response = await _dio
          .clone(options: AppConstant.baseOptions)
          .get<String>(
            workerUrl,
            queryParameters: queryParams,
            options: defaultOptions,
            // cancelToken: cancelToken,
          );

      return _extractMagnetLinks(response.data!);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: "Error extracting magnet links",
        error: e,
      );
    }
  }

  List<String> _extractMagnetLinks(String htmlContent) {
    final List<String> magnetLinks = [];
    try {
      final matches = AppConstant.regexMagnet.allMatches(htmlContent);
      magnetLinks.addAll(matches.map((m) => m.group(0)!));
    } catch (e) {
      debugPrint('Magnet link extraction error: $e');
    }
    return magnetLinks;
  }

  Future<T> _handleRequest<T>({
    required Future<Response> Function() request,
  }) async {
    try {
      final response = await request();
      return await compute(deserializeTorrentResList, response.data!) as T;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } on FormatException catch (e) {
      throw AppException.parseError(error: e);
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: "Unexpected error occurred",
        error: e,
      );
    }
  }
}

List<TorrentRes> deserializeTorrentResList(dynamic json) {
  if (json is String) {
    final List<dynamic> data = jsonDecode(json);
    return data.map((e) => TorrentRes.fromJson(e)).toList();
  }
  return [];
}
