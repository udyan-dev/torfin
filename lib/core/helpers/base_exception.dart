import 'dart:io';

import 'package:dio/dio.dart';

import '../utils/string_constants.dart';

class BaseException implements Exception {
  final BaseExceptionType type;
  final String message;
  final int? statusCode;
  final Object? error;

  const BaseException({
    required this.type,
    required this.message,
    this.statusCode,
    this.error,
  });

  factory BaseException.fromDioError(DioException e) {
    final statusCode = e.response?.statusCode;

    return switch (e.type) {
      DioExceptionType.cancel => BaseException(
        type: BaseExceptionType.cancel,
        message: requestCancelledMessage,
        statusCode: statusCode,
        error: e.response,
      ),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.connectionError => BaseException(
        type: BaseExceptionType.connectionTimeout,
        message: connectionFailedMessage,
        statusCode: statusCode,
        error: e.response,
      ),
      DioExceptionType.sendTimeout => BaseException(
        type: BaseExceptionType.sendTimeout,
        message: sendTimeoutMessage,
        statusCode: statusCode,
        error: e.response,
      ),
      DioExceptionType.receiveTimeout => BaseException(
        type: BaseExceptionType.receiveTimeout,
        message: receiveTimeoutMessage,
        statusCode: statusCode,
        error: e.response,
      ),
      DioExceptionType.badResponse => BaseException(
        type: BaseExceptionType.badResponse,
        message: e.response?.statusMessage ?? badResponseMessage,
        statusCode: statusCode,
        error: e.response,
      ),
      DioExceptionType.badCertificate => BaseException(
        type: BaseExceptionType.badCertificate,
        message: badCertificateMessage,
        statusCode: statusCode,
        error: e.response,
      ),
      DioExceptionType.unknown => _handleUnknownError(e, statusCode),
    };
  }

  static BaseException _handleUnknownError(DioException e, int? statusCode) {
    if (e.error is SocketException) {
      return BaseException(
        type: BaseExceptionType.noInternet,
        message: noInternetError,
        statusCode: statusCode,
        error: e.response,
      );
    }
    if (e.error is HttpException) {
      return BaseException(
        type: BaseExceptionType.noInternet,
        message: serverConnectionError,
        statusCode: statusCode,
        error: e.response,
      );
    }
    return BaseException(
      type: BaseExceptionType.unknown,
      message: e.message ?? unknownErrorMessage,
      statusCode: statusCode,
      error: e.response,
    );
  }

  factory BaseException.parseError({Object? error}) {
    return BaseException(
      type: BaseExceptionType.parseError,
      message: parseDataError,
      error: error,
    );
  }

  @override
  String toString() => 'BaseException: $message (Type: $type)';
}

enum BaseExceptionType {
  cancel,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badResponse,
  noInternet,
  unknown,
  badCertificate,
  parseError,
  insufficientCoins,
}
