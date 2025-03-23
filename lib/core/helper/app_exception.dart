import 'dart:io';

import 'package:dio/dio.dart';

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
    final statusCode = e.response?.statusCode;

    // Handle specific Dio exceptions
    switch (e.type) {
      case DioExceptionType.cancel:
        return AppException(
          type: AppExceptionType.cancel,
          message: 'Request was cancelled by the user or system.',
          statusCode: statusCode,
          error: e.response, // Pass e.response to the error field
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        return AppException(
          type: AppExceptionType.connectionTimeout,
          message: 'Connection failed. Please check your internet connection.',
          statusCode: statusCode,
          error: e.response, // Pass e.response to the error field
        );
      case DioExceptionType.sendTimeout:
        return AppException(
          type: AppExceptionType.sendTimeout,
          message: 'Sending request failed. The server is not responding.',
          statusCode: statusCode,
          error: e.response, // Pass e.response to the error field
        );
      case DioExceptionType.receiveTimeout:
        return AppException(
          type: AppExceptionType.receiveTimeout,
          message: 'Receive response failed. The server might be slow.',
          statusCode: statusCode,
          error: e.response, // Pass e.response to the error field
        );
      case DioExceptionType.badResponse:
        return AppException(
          type: AppExceptionType.badResponse,
          message: e.response?.statusMessage ?? 'Bad response from the server.',
          statusCode: statusCode,
          error: e.response, // Pass e.response to the error field
        );
      case DioExceptionType.badCertificate:
        return AppException(
          type: AppExceptionType.badCertificate,
          message:
              'Invalid SSL certificate. Please check the server configuration.',
          statusCode: statusCode,
          error: e.response, // Pass e.response to the error field
        );
      case DioExceptionType.unknown:
        return _handleUnknownError(e, statusCode);
    }
  }

  static AppException _handleUnknownError(DioException e, int? statusCode) {
    // Handle network-related errors such as no internet or DNS issues
    if (e.error is SocketException) {
      return AppException(
        type: AppExceptionType.noInternet,
        message: 'No internet connection. Please check your network settings.',
        statusCode: statusCode,
        error: e.response, // Pass e.response to the error field
      );
    }
    // Handle HttpException (e.g., DNS errors or unreachable host)
    if (e.error is HttpException) {
      return AppException(
        type: AppExceptionType.noInternet,
        message: 'Unable to connect to the server. Please check your network.',
        statusCode: statusCode,
        error: e.response, // Pass e.response to the error field
      );
    }
    // Handle other unknown errors
    return AppException(
      type: AppExceptionType.unknown,
      message: e.message ?? 'An unknown error occurred.',
      statusCode: statusCode,
      error: e.response, // Pass e.response to the error field
    );
  }

  // Factory method to handle parsing errors
  factory AppException.parseError({Object? error}) {
    return AppException(
      type: AppExceptionType.parseError,
      message: 'Failed to parse data received from the server.',
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
