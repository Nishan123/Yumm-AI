import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yumm_ai/features/settings/domain/entities/app_theme_entity.dart';
import 'package:yumm_ai/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:yumm_ai/features/settings/domain/usecases/save_theme_mode_usecase.dart';
import 'package:yumm_ai/features/settings/presentation/providers/light_sensor_provider.dart';

final appThemeControllerProvider =
    StateNotifierProvider<AppThemeController, AppThemeMode>((ref) {
      final controller = AppThemeController(
        getThemeModeUsecase: ref.read(getThemeModeUsecaseProvider),
        saveThemeModeUsecase: ref.read(saveThemeModeUsecaseProvider),
      );
      controller.loadTheme();
      return controller;
    });

class AppThemeController extends StateNotifier<AppThemeMode> {
  AppThemeController({
    required GetThemeModeUsecase getThemeModeUsecase,
    required SaveThemeModeUsecase saveThemeModeUsecase,
  }) : _getThemeModeUsecase = getThemeModeUsecase,
       _saveThemeModeUsecase = saveThemeModeUsecase,
       super(AppThemeMode.system);

  final GetThemeModeUsecase _getThemeModeUsecase;
  final SaveThemeModeUsecase _saveThemeModeUsecase;
  bool _initialized = false;

  Future<void> loadTheme() async {
    if (_initialized) return;
    _initialized = true;
    final result = await _getThemeModeUsecase();
    result.fold((_) {}, (themeMode) => state = themeMode);
  }

  Future<void> updateTheme(AppThemeMode themeMode) async {
    state = themeMode;
    final result = await _saveThemeModeUsecase(themeMode);
    result.fold((_) {}, (_) {});
  }
}

final effectiveThemeModeProvider = Provider<ThemeMode>((ref) {
  final selectedMode = ref.watch(appThemeControllerProvider);

  if (selectedMode == AppThemeMode.auto) {
    final lux = ref
        .watch(lightSensorProvider)
        .maybeWhen<double?>(data: (value) => value, orElse: () => null);

    if (lux != null) {
      return lux < kLowLightThresholdLux ? ThemeMode.dark : ThemeMode.light;
    }

    return ThemeMode.system;
  }

  return selectedMode.toThemeMode();
});
