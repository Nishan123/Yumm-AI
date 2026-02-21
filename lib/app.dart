import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:yumm_ai/app/routes/app_routes.dart';
import 'package:yumm_ai/app/theme/app_theme.dart';
import 'package:yumm_ai/features/bug_report/presentation/providers/screenshot_provider.dart';
import 'package:yumm_ai/features/bug_report/presentation/providers/shake_detector_provider.dart';
import 'package:yumm_ai/features/settings/presentation/providers/theme_provider.dart';

final AppRoutes _routingConfig = AppRoutes();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(shakeDetectorProvider);
    final screenshotController = ref.watch(screenshotControllerProvider);
    final themeMode = ref.watch(effectiveThemeModeProvider);
    return Screenshot(
      controller: screenshotController,
      child: MaterialApp.router(
        title: "Yumm AI",
        theme: getLightTheme(),
        darkTheme: getDarkTheme(),
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        routerConfig: _routingConfig.appRoutes,
      ),
    );
  }
}
