import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/app.dart';
import 'package:yumm_ai/core/services/storage/user_hive_service.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/subscription/subscription_initializer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeRevenueCat();
  final hiveService = HiveService();
  await hiveService.init();
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.get("gemini_api_key"));
  Pushy.listen();
  Pushy.setNotificationListener((data) {
    debugPrint("Received notification: $data");
    String notificationTitle = data['title'] ?? 'Yumm AI';
    String notificationText = data['message'] ?? 'New notification';

    Pushy.notify(notificationTitle, notificationText, data);
    Pushy.clearBadge();
  });
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}
