import 'package:flutter/material.dart';
import 'package:torfin/core/helper/app_exception.dart';

import '../../../core/helper/data_state.dart';

abstract class BaseApiRepository {
  @protected
  Future<DataState<T>> getStateOf<T>({
    required Future<T> Function() request,
  }) async {
    try {
      final response = await request();
      return DataSuccess(response);
    } on AppException catch (error) {
      return DataFailed(error);
    }
  }
}