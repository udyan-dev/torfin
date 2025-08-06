import 'base_exception.dart';

class DataFailed<T> extends DataState<T> {
  const DataFailed(BaseException error) : super(error: error);
}

class DataNotSet<T> extends DataState<T> {
  const DataNotSet();
}

sealed class DataState<T> {
  final T? data;
  final BaseException? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

enum DataStatus { initial, loading, success, error }

extension DataStateX<T> on DataState<T> {
  DataState<R> when<R>({
    required R Function(T data) success,
    Function(BaseException error)? failure,
    Function()? notSet,
  }) {
    return switch (this) {
      DataSuccess(:final data) => DataSuccess<R>(success(data as T)),
      DataFailed(:final error) =>
        failure?.call(error!) ?? DataFailed<R>(error!),
      DataNotSet() => notSet?.call() ?? const DataNotSet(),
    };
  }
}
