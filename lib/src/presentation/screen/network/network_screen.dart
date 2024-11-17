import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torfin/src/presentation/screen/network/bloc/network_bloc.dart';

import '../../../../core/router/dynamic_route.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../injection.dart';
import '../base/base_screen.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final _oopsImage = Flexible(child: SvgPicture.asset(AppAssets.oops));

  final _networkImage =
      Flexible(flex: 3, child: SvgPicture.asset(AppAssets.network));

  get _offlineScreen => PopScope(
        canPop: false,
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: kToolbarHeight),
              _oopsImage,
              _networkImage,
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<NetworkBloc>()..add(NetworkEvent()),
      child: BlocListener<NetworkBloc, NetworkState>(
        listenWhen: (_, state) =>
            state.status == NetworkEnum.offline ||
            state.status == NetworkEnum.online,
        listener: (_, state) {
          if (state.status == NetworkEnum.online) {
            if (Navigator.of(navigationContext).canPop()) {
              Navigator.of(navigationContext).pop();
            }
          } else if (state.status == NetworkEnum.offline) {
            DynamicRouteWidget.push(
              navigationContext,
              _offlineScreen,
            );
          }
        },
        child: BaseScreen(),
      ),
    );
  }
}
