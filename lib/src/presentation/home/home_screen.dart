import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bindings/di.dart';
import '../../../core/helpers/data_state.dart';
import '../../../core/services/notification_service.dart';
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
import '../widgets/download_button_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/notification_widget.dart';
import '../widgets/status_widget.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final CoinsCubit _coinsCubit;
  late final HomeCubit _homeCubit;
  late final TabController _tabController;
  late final NotificationService _notificationService;
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _notificationService = di<NotificationService>();
    final initialIndex = _notificationService.initialTabIndex ?? 0;
    _notificationService.initialTabIndex = null;
    _tabController = TabController(
      length: navigationItems.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _notificationService.onNavigateToTab = _tabController.animateTo;
    _coinsCubit = di<CoinsCubit>();
    _homeCubit = di<HomeCubit>()
      ..getToken()
      ..checkNotificationPermission()
      ..checkDownloadPermission();
    _lifecycleListener = AppLifecycleListener(onResume: _coinsCubit.load);
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _notificationService.onNavigateToTab = null;
    _tabController.dispose();
    if (!_homeCubit.isClosed) _homeCubit.close();
    if (!_coinsCubit.isClosed) _coinsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeCubit),
        BlocProvider.value(value: _coinsCubit),
      ],
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
          child: BlocListener<HomeCubit, HomeState>(
            listenWhen: (p, c) => c.intentUri != null,
            listener: (context, state) {
              if (state.intentUri != null) {
                showAddTorrentDialog(context, initialUri: state.intentUri);
              }
            },
            child: BodyWidget(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.status == DataStatus.initial ||
                      state.status == DataStatus.loading) {
                    return const AnimatedSwitcherWidget(
                      child: StatusWidget(
                        type: StatusType.loading,
                        statusMessage: connectingToServer,
                      ),
                    );
                  }
                  return TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (state.status == DataStatus.error)
                        EmptyStateWidget(
                          center: true,
                          emptyState: state.emptyState,
                          iconColor: context.colors.supportError,
                          onTap: () => context.read<HomeCubit>().getToken(),
                        )
                      else
                        const SearchScreen(),
                      if (state.status == DataStatus.error)
                        EmptyStateWidget(
                          center: true,
                          emptyState: state.emptyState,
                          iconColor: context.colors.supportError,
                          onTap: () => context.read<HomeCubit>().getToken(),
                        )
                      else
                        const TrendingScreen(),
                      const DownloadScreen(),
                      const FavoriteScreen(),
                      const SettingsScreen(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(
          controller: _tabController,
        ),
        floatingActionButton: const DownloadButtonWidget(),
      ),
    );
  }
}
