import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';

final appThemeStorageProvider = Provider<AppThemeStorage>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return AppThemeStorage(prefs: prefs);
});

class AppThemeStorage {
  AppThemeStorage({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;
  static const String _keyThemeMode = 'app_theme_mode';

  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(_keyThemeMode, themeMode);
  }

  String? getThemeMode() {
    return _prefs.getString(_keyThemeMode);
  }
}
