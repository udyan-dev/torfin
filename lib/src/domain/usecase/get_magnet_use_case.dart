import 'package:dio/dio.dart';
import 'package:torfin/src/domain/repository/torfin_repository.dart';

import '../../../core/helper/base_usecase.dart';
import '../../../core/helper/data_state.dart';

class GetMagnetUseCase extends BaseUseCase<List<String>, String> {
  final TorfinRepository torfinRepository;

  GetMagnetUseCase({required this.torfinRepository});

  @override
  Future<DataState<List<String>>> call(
    String params, {
    required CancelToken cancelToken,
  }) async {
    var magnet = await torfinRepository.magnet(
      site: params,
      cancelToken: cancelToken,
    );
    return magnet;
  }
}
