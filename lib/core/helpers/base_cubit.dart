import 'package:flutter_bloc/flutter_bloc.dart';

import 'data_state.dart';

abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  bool _isClosed = false;

  @override
  Future<void> close() async {
    if (_isClosed) return;
    _isClosed = true;
    await closeToken();
    return super.close();
  }

  Future<void> closeToken();

  @override
  @pragma('vm:prefer-inline')
  void emit(State state) {
    if (_isClosed || isClosed) return;
    super.emit(state);
  }

  @pragma('vm:prefer-inline')
  bool isSuccess<T>(DataState<T> response) => response is DataSuccess<T>;
}
