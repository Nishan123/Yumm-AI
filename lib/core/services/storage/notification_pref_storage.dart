import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';

final notificationPrefStorageProvider = Provider((ref){
  return NotificationPrefStorage(pref: ref.read(sharedPreferencesProvider));
});

class NotificationPrefStorage {
  static const String _notificatoinPrefKey ="notification_pref_key";
  final SharedPreferences _pref;

  NotificationPrefStorage({
    required SharedPreferences pref
  }):_pref=pref;

  bool getCurrentNotificationPred(){
    return _pref.getBool(_notificatoinPrefKey)??true;
  }

  void storeNotificationPref(bool value){
     _pref.setBool(_notificatoinPrefKey, value);
  }
}