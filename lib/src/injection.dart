import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:torfin/core/utils/app_constants.dart';
import 'package:torfin/src/data/repository/common_repository_imp.dart';
import 'package:torfin/src/data/repository/storage_repository_imp.dart';
import 'package:torfin/src/data/source/remote/api_service/api_service.dart';
import 'package:torfin/src/domain/repository/common_repository.dart';
import 'package:torfin/src/domain/repository/storage_repository.dart';
import 'package:torfin/src/domain/usecase/get_token_usecase.dart';
import 'package:torfin/src/presentation/screen/network/bloc/network_bloc.dart';
import 'package:torfin/src/presentation/screen/splash/bloc/splash_bloc.dart';

import '../core/router/dynamic_route.dart';
import 'data/source/local/storage_service.dart';

final di = GetIt.I;
final navigationContext = di<GlobalKey<NavigatorState>>().currentContext!;

Future<void> inject() async {
  await StorageService.init();
  di.registerSingleton<CancelToken>(CancelToken());
  di.registerSingleton<StorageService>(StorageService());
  di.registerSingleton<GlobalKey<NavigatorState>>(
      DynamicRouteWidget.navigatorKey);
  di.registerSingleton<Connectivity>(Connectivity());
  di.registerSingleton<NetworkBloc>(
      NetworkBloc(networkListener: di<Connectivity>().onConnectivityChanged));
  di.registerSingleton<Dio>(Dio(BaseOptions(
    connectTimeout: AppConstants.timeout,
    sendTimeout: AppConstants.timeout,
    receiveTimeout: AppConstants.timeout,
  )));
  di.registerSingleton<ApiService>(ApiService(di()));
  di.registerSingleton<CommonRepository>(CommonRepositoryImp(apiService: di()));
  di.registerSingleton<StorageRepository>(
      StorageRepositoryImp(storageService: di()));
  di.registerSingleton<GetTokenUseCase>(
      GetTokenUseCase(commonRepository: di(), storageRepository: di()));
  di.registerFactory<SplashBloc>(
      () => SplashBloc(getTokenUseCase: di(), cancelToken: di()));
}
