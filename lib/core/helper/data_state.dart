import 'package:torfin/core/helper/app_exception.dart';

class DataFailed<T> extends DataState<T> {
  const DataFailed(AppException error) : super(error: error);
}

class DataNotSet<T> extends DataState<T> {
  const DataNotSet();
}

abstract class DataState<T> {
  final T? data;
  final AppException? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

enum DataEnum {
  initial,
  loading,
  success,
  failure;
}
