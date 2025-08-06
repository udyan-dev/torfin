import 'package:flutter/material.dart';

import '../utils/string_constants.dart';
import 'base_exception.dart';
import 'data_state.dart';

abstract class BaseRepository {
  @protected
  Future<DataState<T>> getStateOf<T>({
    required Future<T> Function() request,
  }) async {
    try {
      return DataSuccess(await request());
    } on BaseException catch (exception) {
      return exception.type == BaseExceptionType.cancel
          ? const DataNotSet()
          : DataFailed(exception);
    } catch (error) {
      return DataFailed(
        BaseException(
          type: BaseExceptionType.unknown,
          message: '$repositoryError: ${error.toString()}',
        ),
      );
    }
  }

  @protected
  Map<String, dynamic> get queryTimeStamp => {
    "_": DateTime.now().millisecondsSinceEpoch.toString(),
  };
}
