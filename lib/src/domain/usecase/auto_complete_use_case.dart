import 'package:dio/dio.dart';
import 'package:torfin/src/domain/repository/torfin_repository.dart';

import '../../../core/helper/base_usecase.dart';
import '../../../core/helper/data_state.dart';

class AutoCompleteUseCase extends BaseUseCase<dynamic, String> {
  final TorfinRepository torfinRepository;

  AutoCompleteUseCase({required this.torfinRepository});

  @override
  Future<DataState<dynamic>> call(
    String params, {
    required CancelToken cancelToken,
  }) async {
    var result = await torfinRepository.autoComplete(
      search: params,
      cancelToken: cancelToken,
    );
    return result;
  }
}
