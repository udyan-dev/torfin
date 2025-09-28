import 'package:flutter/material.dart';
import '../../src/domain/repositories/storage_repository.dart';
import '../helpers/data_state.dart';

class ThemeService {
  ThemeService({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;

  final StorageRepository _storageRepository;
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.system);

  ValueNotifier<ThemeMode> get themeNotifier => _notifier;
  ThemeMode get current => _notifier.value;

  Future<void> init() async {
    try {
      final result = await _storageRepository.getTheme();
      if (result is DataSuccess<ThemeMode>) {
        _notifier.value = result.data!;
      }
    } catch (_) {
      _notifier.value = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    if (_notifier.value == theme) return;
    try {
      final result = await _storageRepository.setTheme(theme);
      if (result is DataSuccess<bool>) {
        _notifier.value = theme;
      } else {
        _notifier.value = ThemeMode.system;
      }
    } catch (_) {
      _notifier.value = ThemeMode.system;
    }
  }

  void dispose() => _notifier.dispose();
}
