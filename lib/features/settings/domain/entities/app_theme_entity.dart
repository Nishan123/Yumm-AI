import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, system, auto }

extension AppThemeModeX on AppThemeMode {
  String get storageValue {
    switch (this) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
      case AppThemeMode.auto:
        return 'auto';
    }
  }

  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.auto:
        return ThemeMode.system;
    }
  }
}

AppThemeMode appThemeModeFromStorage(String? value) {
  switch (value) {
    case 'light':
      return AppThemeMode.light;
    case 'dark':
      return AppThemeMode.dark;
    case 'system':
      return AppThemeMode.system;
    case 'auto':
      return AppThemeMode.auto;
    default:
      return AppThemeMode.light;
  }
}
