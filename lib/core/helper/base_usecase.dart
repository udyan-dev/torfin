import 'package:dio/dio.dart';

import 'data_state.dart';

abstract class BaseUseCase<Type, Param> {
  Future<DataState<Type>> call(
    Param params, {
    required CancelToken cancelToken,
  });

  bool isSuccess<T>(DataState<T> response) {
    return response is DataSuccess;
  }
}

class NoParams {}
