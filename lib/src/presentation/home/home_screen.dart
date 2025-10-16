import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bindings/di.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/string_constants.dart';
import '../download/download_screen.dart';
import '../favorite/favorite_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import '../trending/trending_screen.dart';
import '../widgets/animated_switcher_widget.dart';
import '../widgets/body_widget.dart';
import '../widgets/bottom_navigation_bar_widget.dart';
import '../widgets/coins/cubit/coins_cubit.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/notification_widget.dart';
import '../widgets/status_widget.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CoinsCubit _coinsCubit;
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _coinsCubit = di<CoinsCubit>();
    _homeCubit = di<HomeCubit>()
      ..getToken()
      ..checkNotificationPermission()
      ..checkDownloadPermission();
  }

  @override
  void dispose() {
    if (!_homeCubit.isClosed) _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeCubit),
        BlocProvider.value(value: _coinsCubit),
      ],
      child: DefaultTabController(
        animationDuration: Duration.zero,
        length: navigationItems.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocListener<HomeCubit, HomeState>(
            listenWhen: (p, c) => p.notification != c.notification,
            listener: (context, state) {
              switch (state.notification) {
                case final n?:
                  NotificationWidget.notify(context, n);
                case null:
                  break;
              }
            },
            child: BodyWidget(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) => AnimatedSwitcherWidget(
                  child: switch (state.status) {
                    DataStatus.initial ||
                    DataStatus.loading => const StatusWidget(
                      type: StatusType.loading,
                      statusMessage: connectingToServer,
                    ),
                    DataStatus.success => const TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SearchScreen(),
                        TrendingScreen(),
                        DownloadScreen(),
                        FavoriteScreen(),
                        SettingsScreen(),
                      ],
                    ),
                    DataStatus.error => EmptyStateWidget(
                      center: true,
                      emptyState: state.emptyState,
                      iconColor: context.colors.supportError,
                      onTap: () => context.read<HomeCubit>().getToken(),
                    ),
                  },
                ),
              ),
            ),
          ),
          bottomNavigationBar: const BottomNavigationBarWidget(),
        ),
      ),
    );
  }
}
