import 'package:flutter_bloc/flutter_bloc.dart';

import 'data_state.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState);

  @override
  Future<void> close() {
    closeToken();
    return super.close();
  }

  Future<void> closeToken();

  bool isSuccess<T>(DataState<T> response) {
    return response is DataSuccess;
  }
}
