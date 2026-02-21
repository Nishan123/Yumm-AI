import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/services/storage/app_theme_storage.dart';
import 'package:yumm_ai/features/settings/domain/entities/app_theme_entity.dart';

final themeLocalDatasourceProvider = Provider<IThemeLocalDatasource>((ref) {
  final storage = ref.read(appThemeStorageProvider);
  return ThemeLocalDatasource(appThemeStorage: storage);
});

abstract interface class IThemeLocalDatasource {
  Future<AppThemeMode> getSavedTheme();
  Future<AppThemeMode> cacheTheme(AppThemeMode themeMode);
}

class ThemeLocalDatasource implements IThemeLocalDatasource {
  final AppThemeStorage _appThemeStorage;

  ThemeLocalDatasource({required AppThemeStorage appThemeStorage})
    : _appThemeStorage = appThemeStorage;

  @override
  Future<AppThemeMode> getSavedTheme() async {
    final storedValue = _appThemeStorage.getThemeMode();
    return appThemeModeFromStorage(storedValue);
  }

  @override
  Future<AppThemeMode> cacheTheme(AppThemeMode themeMode) async {
    await _appThemeStorage.saveThemeMode(themeMode.storageValue);
    return themeMode;
  }
}
