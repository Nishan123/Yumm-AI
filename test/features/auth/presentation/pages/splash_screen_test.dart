import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/presentation/pages/splash_screen.dart';

void main() {
  testWidgets(
    'SplashScreen renders without crashing',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
          GoRoute(
            path: '/signup',
            name: 'signup',
            builder: (_, __) => const Scaffold(body: Text('Signup')),
          ),
          GoRoute(
            path: '/main',
            name: 'main',
            builder: (_, __) => const Scaffold(body: Text('Main')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      // Pump 1 frame — SplashScreen has started its animation + timer
      await tester.pump();

      // Skip the 2.5s delay by jumping the fake clock
      await tester.pump(const Duration(seconds: 3));

      // The scaffold is always present while the widget is alive
      expect(find.byType(Scaffold), findsWidgets);
    },
    timeout: const Timeout(Duration(seconds: 10)),
  );
}
