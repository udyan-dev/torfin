import 'dart:io';

import 'package:torfin/src/data/source/remote/dio_service.dart';
import 'package:torfin/src/env.dart';

import '../../../../core/helper/app_exception.dart';
import '../../../../core/utils/app_constant.dart';

class TokenService {
  final DioService _dioService;

  TokenService({required DioService dioService}) : _dioService = dioService;

  Future<String> getApiToken() async {
    try {
      final apiKey = await _fetchApiKey();
      if (apiKey.isEmpty) throw Exception('Failed to fetch API key.');
      final token = await _fetchToken(apiKey);
      if (token.isEmpty) throw Exception('Failed to fetch token.');
      return token;
    } on Exception catch (e) {
      throw AppException(type: AppExceptionType.unknown, message: e.toString());
    }
  }

  Future<String> _fetchApiKey() async {
    final response = await _dioService.dio.get(
      '',
      options: _dioService.defaultOptions,
    );
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to fetch API key: HTTP ${response.statusCode}');
    }
    return AppConstant.regexForJs.firstMatch(response.data)?.group(0) ?? '';
  }

  Future<String> _fetchToken(String apiKey) async {
    final jsFileLink = '${Env.baseUrl}$apiKey';
    final response = await _dioService.dio.get(
      jsFileLink,
      options: _dioService.defaultOptions,
    );
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to fetch token: HTTP ${response.statusCode}');
    }
    return AppConstant.regexForKey.firstMatch(response.data)?.group(1) ?? '';
  }
}
