import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppException implements Exception {
  final AppExceptionType type;
  final String message;
  final int? statusCode;
  final Object? error;

  const AppException({
    required this.type,
    required this.message,
    this.statusCode,
    this.error,
  });

  factory AppException.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return AppException(
          type: AppExceptionType.cancel,
          message: 'Request cancelled',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        return AppException(
          type: AppExceptionType.connectionTimeout,
          message: 'Connection failed',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.sendTimeout:
        return AppException(
          type: AppExceptionType.sendTimeout,
          message: 'Send request failed',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.receiveTimeout:
        return AppException(
          type: AppExceptionType.receiveTimeout,
          message: 'Receive response failed',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        return AppException(
          type: AppExceptionType.badResponse,
          message: e.response?.statusMessage ?? 'Bad response',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.unknown:
        return _handleUnknownError(e);
      case DioExceptionType.badCertificate:
        return AppException(
          type: AppExceptionType.badCertificate,
          message: 'Invalid certificate',
          statusCode: e.response?.statusCode,
        );
    }
  }

  static AppException _handleUnknownError(DioException e) {
    if (e.error is SocketException) {
      return AppException(
        type: AppExceptionType.noInternet,
        message: 'No internet connection',
        statusCode: e.response?.statusCode,
      );
    }
    return AppException(
      type: AppExceptionType.unknown,
      message: e.message ?? 'Unknown error occurred',
      statusCode: e.response?.statusCode,
    );
  }

  factory AppException.parseError({Object? error}) {
    debugPrint('Parsing error: $error');
    return AppException(
      type: AppExceptionType.parseError,
      message: 'Failed to parse data',
      error: error,
    );
  }

  @override
  String toString() => 'AppException: $message (Type: $type)';
}

enum AppExceptionType {
  cancel,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badResponse,
  noInternet,
  unknown,
  badCertificate,
  parseError,
}
