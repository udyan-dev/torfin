import 'package:dio/dio.dart';

import 'data_state.dart';

abstract class BaseUseCase<R, Param> {
  Future<DataState<R>> call(Param params, {required CancelToken cancelToken});

  bool isSuccess<T>(DataState<T> response) => response is DataSuccess;
}

class NoParams {}
