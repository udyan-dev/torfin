import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../../core/helpers/data_state.dart';
import '../../../../core/utils/string_constants.dart';
import '../../../data/engine/engine.dart';
import '../../../data/engine/models/session.dart';
import '../../../data/engine/session.dart';
import '../../../domain/repositories/storage_repository.dart';
import '../../widgets/notification_widget.dart';
import '../../shared/notification_builders.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required StorageRepository storageRepository,
    required SessionService sessionService,
    required Engine engine,
  }) : _storageRepository = storageRepository,
       _sessionService = sessionService,
       _engine = engine,
       super(const SettingsState());

  final StorageRepository _storageRepository;
  final SessionService _sessionService;
  final Engine _engine;

  Future<void> initialize() async {
    _sessionService.startPeriodicFetch();

    final results = await Future.wait([
      _storageRepository.getEnableSuggestions(),
      _storageRepository.getNsfw(),
      _sessionService.fetchSession(),
    ]);

    final enableSuggestionsResult = results[0] as DataState<bool>;
    final nsfwResult = results[1] as DataState<String>;
    final sessionResult = results[2] as Session;

    final enableSuggestions = enableSuggestionsResult.data ?? true;
    final nsfwValue = nsfwResult.data ?? nsfwDisabledValue;
    final nsfw = nsfwValue == nsfwEnabledValue;
    final enableSpeedLimits =
        sessionResult.speedLimitDownEnabled == true ||
        sessionResult.speedLimitUpEnabled == true;

    emit(
      state.copyWith(
        enableSuggestions: enableSuggestions,
        nsfw: nsfw,
        enableSpeedLimits: enableSpeedLimits,
        downloadSpeedLimit:
            sessionResult.speedLimitDown?.toString() ?? defaultSpeedValue,
        uploadSpeedLimit:
            sessionResult.speedLimitUp?.toString() ?? defaultSpeedValue,
        downloadQueueSize:
            sessionResult.downloadQueueSize?.toString() ?? defaultPortValue,
        peerPort: sessionResult.peerPort?.toString() ?? defaultPortValue,
      ),
    );
  }

  Future<void> setEnableSuggestions(bool enable) async {
    emit(state.copyWith(enableSuggestions: enable));
    await _storageRepository.setEnableSuggestions(enable);
  }

  Future<void> setNsfw(bool enable) async {
    emit(state.copyWith(nsfw: enable));
    await _storageRepository.setNsfw(
      enable ? nsfwEnabledValue : nsfwDisabledValue,
    );
  }

  Future<void> updateSession(SessionBase sessionBase) async {
    try {
      if (_sessionService.session == null) {
        await _sessionService.fetchSession();
      }

      await _sessionService.session?.update(sessionBase);
      await _sessionService.fetchSession();

      final session = _sessionService.session;
      final enableSpeedLimits =
          session?.speedLimitDownEnabled == true ||
          session?.speedLimitUpEnabled == true;

      emit(
        state.copyWith(
          enableSpeedLimits: enableSpeedLimits,
          downloadSpeedLimit:
              session?.speedLimitDown?.toString() ?? defaultSpeedValue,
          uploadSpeedLimit:
              session?.speedLimitUp?.toString() ?? defaultSpeedValue,
          downloadQueueSize:
              session?.downloadQueueSize?.toString() ?? defaultPortValue,
          peerPort: session?.peerPort?.toString() ?? defaultPortValue,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          notification: errorNotification(failedToUpdateSettings, e.toString()),
        ),
      );
    }
  }

  Future<void> resetTorrentSettings() async {
    try {
      await _engine.resetSettings();
      await _sessionService.fetchSession();

      final session = _sessionService.session;
      final enableSpeedLimits =
          session?.speedLimitDownEnabled == true ||
          session?.speedLimitUpEnabled == true;

      emit(
        state.copyWith(
          enableSpeedLimits: enableSpeedLimits,
          downloadSpeedLimit:
              session?.speedLimitDown?.toString() ?? defaultSpeedValue,
          uploadSpeedLimit:
              session?.speedLimitUp?.toString() ?? defaultSpeedValue,
          downloadQueueSize:
              session?.downloadQueueSize?.toString() ?? defaultPortValue,
          peerPort: session?.peerPort?.toString() ?? defaultPortValue,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          notification: errorNotification(failedToResetSettings, e.toString()),
        ),
      );
    }
  }

  Future<void> rateTheApp() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      await inAppReview.openStoreListing();
    } catch (e) {
      emit(
        state.copyWith(
          notification: errorNotification(failedToOpenPlayStore, e.toString()),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _sessionService.stopPeriodicFetch();
    return super.close();
  }
}
