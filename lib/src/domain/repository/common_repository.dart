import 'package:torfin/core/helper/data_state.dart';

abstract class CommonRepository {
  Future<DataState<String>> getToken();
}
