import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/app/routes/app_routes.dart';
import 'package:yumm_ai/app/theme/app_theme.dart';
import 'package:yumm_ai/core/services/storage/user_hive_service.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/bug_report/presentation/providers/shake_detector_provider.dart';
import 'package:yumm_ai/features/bug_report/presentation/providers/screenshot_provider.dart';
import 'package:screenshot/screenshot.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

    // Clear iOS badge count
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize shake detector
    ref.watch(shakeDetectorProvider);
    final screenshotController = ref.watch(screenshotControllerProvider);

    final AppRoutes routingConfig = AppRoutes();
    return Screenshot(
      controller: screenshotController,
      child: MaterialApp.router(
        title: "Yumm AI",
        theme: getAppTheme(),
        debugShowCheckedModeBanner: false,
        routeInformationParser: routingConfig.appRoutes.routeInformationParser,
        routeInformationProvider:
            routingConfig.appRoutes.routeInformationProvider,
        routerDelegate: routingConfig.appRoutes.routerDelegate,
      ),
    );
  }
}
