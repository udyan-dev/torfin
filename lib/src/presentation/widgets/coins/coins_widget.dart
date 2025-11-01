import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/bindings/env.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/string_constants.dart';
import '../../shared/notification_builders.dart';
import '../button_widget.dart';
import '../dialog_widget.dart';
import '../loading_widget.dart';
import '../notification_widget.dart';
import 'cubit/coins_cubit.dart';

class CoinsWidget extends StatefulWidget {
  const CoinsWidget({super.key});

  @override
  State<CoinsWidget> createState() => _CoinsWidgetState();
}

class _CoinsWidgetState extends State<CoinsWidget> {
  RewardedInterstitialAd? _rewardedInterstitialAd;
  final _isAdLoadingNotifier = ValueNotifier<bool>(false);
  bool _isAdShowing = false;
  int _rewardAmount = 0;

  @override
  void dispose() {
    _disposeAd();
    _isAdLoadingNotifier.dispose();
    super.dispose();
  }

  void _disposeAd() {
    _rewardedInterstitialAd?.dispose();
    _rewardedInterstitialAd = null;
  }

  void _loadRewardedAd(BuildContext dialogContext) {
    if (_isAdLoadingNotifier.value || _rewardedInterstitialAd != null) return;

    _isAdLoadingNotifier.value = true;

    RewardedInterstitialAd.load(
      adUnitId: Env.adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (!mounted || !_isAdLoadingNotifier.value) {
            ad.dispose();
            return;
          }
          _rewardedInterstitialAd = ad;
          _configureAdCallbacks();
          _isAdLoadingNotifier.value = false;
          _showRewardedAd(dialogContext);
        },
        onAdFailedToLoad: (error) {
          if (!mounted || !_isAdLoadingNotifier.value) return;
          _isAdLoadingNotifier.value = false;
          _closeDialog(dialogContext);
          _showErrorNotification(error.message);
        },
      ),
    );
  }

  void _cancelAdLoading(BuildContext dialogContext) {
    if (_isAdLoadingNotifier.value) {
      _isAdLoadingNotifier.value = false;
      _disposeAd();
    }
    _closeDialog(dialogContext);
  }

  void _configureAdCallbacks() {
    _rewardedInterstitialAd
        ?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isAdShowing = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isAdShowing = false;
        _disposeAd();
        if (mounted) {
          _closeDialog(context);
          if (_rewardAmount > 0) {
            context.read<CoinsCubit>().add(_rewardAmount);
            NotificationWidget.notify(context, successNotification(coinsAdded));
          }
        }
        _rewardAmount = 0;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isAdShowing = false;
        _disposeAd();
        if (mounted) {
          _closeDialog(context);
          _showErrorNotification(error.message);
        }
        _rewardAmount = 0;
      },
      onAdImpression: (ad) {},
      onAdClicked: (ad) {},
    );
  }

  void _showRewardedAd(BuildContext dialogContext) {
    if (_rewardedInterstitialAd == null || _isAdShowing) return;

    _rewardedInterstitialAd?.show(
      onUserEarnedReward: (ad, reward) {
        _rewardAmount = reward.amount.toInt();
      },
    );
  }

  void _showErrorNotification(String errorMessage) {
    if (!mounted) return;
    NotificationWidget.notify(
      context,
      errorNotification(errorMessage, adBlockerOrInternetMessage),
    );
  }

  void _showCoinsInfo() {
    NotificationWidget.notify(context, infoNotification(coinsInfoMessage));
  }

  void _closeDialog(BuildContext dialogContext) {
    if (!mounted) return;
    Navigator.of(dialogContext).maybePop();
  }

  void _showAdDialog() {
    showAppDialog(
      context: context,
      builder: (dialogContext) => _AdDialogContent(
        isAdLoadingNotifier: _isAdLoadingNotifier,
        onCancel: () => _cancelAdLoading(dialogContext),
        onWatch: () => _loadRewardedAd(dialogContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinsCubit, CoinsState>(
      builder: (context, state) {
        final showPlus = state.canWatchAd;
        return InkWell(
          onTap: showPlus ? _showAdDialog : _showCoinsInfo,
          borderRadius: BorderRadius.circular(1000),
          child: Stack(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: context.colors.supportCautionMinor),
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 6,
                    right: 6,
                    bottom: 6,
                    left: showPlus ? 6 : 4,
                  ),
                  child: Row(
                    children: [
                      if (showPlus)
                        SvgPicture.asset(
                          AppAssets.icAdd,
                          width: 20,
                          height: 20,
                          colorFilter:
                              context.colors.supportCautionMinor.colorFilter,
                        ),
                      const SizedBox(width: 6),
                      AppText.bodyCompact01(
                        '${state.coins}',
                        color: context.colors.supportCautionMinor,
                      ),
                      const SizedBox(width: kToolbarHeight / 2),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Transform.scale(
                  scale: 1.75,
                  child: RepaintBoundary(
                    child: Lottie.asset(
                      AppAssets.icCoinLottie,
                      frameRate: FrameRate.max,
                      repeat: true,
                      filterQuality: FilterQuality.high,
                      addRepaintBoundary: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdDialogContent extends StatelessWidget {
  final ValueNotifier<bool> isAdLoadingNotifier;
  final VoidCallback onCancel;
  final VoidCallback onWatch;

  const _AdDialogContent({
    required this.isAdLoadingNotifier,
    required this.onCancel,
    required this.onWatch,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          onCancel();
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isAdLoadingNotifier,
        builder: (context, isLoading, child) {
          return DialogWidget(
            title: watchAdForCoins,
            content: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: AppText.body01(
                watchAdMessage,
                color: context.colors.textSecondary,
              ),
            ),
            actions: Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    backgroundColor: context.colors.buttonSecondary,
                    buttonText: cancel,
                    onTap: onCancel,
                  ),
                ),
                Expanded(
                  child: ButtonWidget(
                    backgroundColor: context.colors.buttonPrimary,
                    buttonText: watchAd,
                    onTap: isLoading ? null : onWatch,
                    trailing: isLoading ? const LoadingWidget() : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
