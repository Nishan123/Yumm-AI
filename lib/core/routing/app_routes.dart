import 'package:go_router/go_router.dart';
import 'package:yumm_ai/screens/main/main_screen.dart';
import 'package:yumm_ai/screens/scanner/scanner_screen.dart';

class AppRoutes {
  AppRoutes();
  final GoRouter appRoutes = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        name: "main",
        builder: (context, state) {
          return MainScreen();
        },
      ),
      GoRoute(
        path: "/scanner",
        name: "scanner",
        builder: (context, state) {
          return ScannerScreen();
        },
      ),
    ],
  );
}
