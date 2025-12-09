import 'package:go_router/go_router.dart';
import 'package:yumm_ai/screens/auth/login_screen.dart';
import 'package:yumm_ai/screens/auth/signup_screen.dart';
import 'package:yumm_ai/screens/main/main_screen.dart';
import 'package:yumm_ai/screens/scanner/scanner_screen.dart';
import 'package:yumm_ai/screens/splash/splash_screen.dart';

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
      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: "/signup",
        name: "signup",
        builder: (context, state) {
          return SignupScreen();
        },
      ),
      GoRoute(
        path: "/splash",
        name: "splash",
        builder: (context, state) {
          return SplashScreen();
        },
      ),
    ],
  );
}
