import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/helper/app_exception.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_routes.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://snowfl.com/')
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  Future<String> getApiToken();
}
