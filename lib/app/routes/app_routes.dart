import 'package:go_router/go_router.dart';
import 'package:yumm_ai/features/auth/presentation/pages/login_screen.dart';
import 'package:yumm_ai/features/auth/presentation/pages/signup_screen.dart';
import 'package:yumm_ai/features/auth/presentation/pages/splash_screen.dart';
import 'package:yumm_ai/features/chef/presentation/pages/chefs_screen.dart';
import 'package:yumm_ai/features/chef/presentation/pages/macro_chef_screen.dart';
import 'package:yumm_ai/features/chef/presentation/pages/master_chef_screen.dart';
import 'package:yumm_ai/features/chef/presentation/pages/pantry_chef_screen.dart';
import 'package:yumm_ai/features/cooking/presentation/pages/cooking_screen.dart';
import 'package:yumm_ai/features/dashboard/presentation/pages/main_screen.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/pages/kitchen_tools_screen.dart';
import 'package:yumm_ai/features/pantry_inventory/presentation/pages/pantry_inventory_screen.dart';
import 'package:yumm_ai/features/profile/presentation/pages/profile_screen.dart';
import 'package:yumm_ai/features/save_recipe/presentation/pages/saved_recipe_screen.dart';
import 'package:yumm_ai/features/scanner/presentation/pages/scanner_screen.dart';
import 'package:yumm_ai/features/settings/presentation/pages/setting_screen.dart';
import 'package:yumm_ai/features/shopping_list/presentation/pages/add_shopping_list_screen.dart';
import 'package:yumm_ai/features/shopping_list/presentation/pages/shopping_list_screen.dart';
import 'package:yumm_ai/features/subscriptions/presentation/pages/available_plans_screen.dart';

class AppRoutes {
  AppRoutes();
  final GoRouter appRoutes = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        name: "splash",
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: "/main",
        name: "main",
        builder: (context, state) {
          return MainScreen();
        },
      ),
      GoRoute(
        path: "/setting",
        name: "setting",
        builder: (context, state) {
          return SettingScreen();
        },
      ),
      GoRoute(
        path: "/chefs",
        name: "chefs",
        builder: (context, state) {
          return ChefsScreen();
        },
      ),
      GoRoute(
        path: "/cooking",
        name: "cooking",
        builder: (context, state) {
          return CookingScreen();
        },
      ),
      GoRoute(
        path: "/plans",
        name: "plans",
        builder: (context, state) {
          return AvailablePlansScreen();
        },
      ),
      GoRoute(
        path: "/scanner",
        name: "scanner",
        builder: (context, state) {
          final scannerType = state.uri.queryParameters["selectedScanner"];
          return ScannerScreen(selectedScanner: scannerType!);
        },
      ),
      GoRoute(
        path: "/profile",
        name: "profile",
        builder: (context, state) {
          return ProfileScreen();
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

      // Screens redirected from "Items Screen"
      GoRoute(
        path: "/saved_recipe",
        name: "saved_recipe",
        builder: (context, state) {
          return SavedRecipeScreen();
        },
      ),
      GoRoute(
        path: "/shopping_list",
        name: "shopping_list",
        builder: (context, state) {
          return ShoppingListScreen();
        },
      ),
      GoRoute(
        path: "/kitchen_tools",
        name: "kitchen_tools",
        builder: (context, state) {
          return KitchenToolsScreen();
        },
      ),
      GoRoute(
        path: "/pantry_inventory",
        name: "pantry_inventory",
        builder: (context, state) {
          return PantryInventoryScreen();
        },
      ),
      GoRoute(
        path: "/add_shopping_list",
        name: "add_shopping_list",
        builder: (context, state) {
          return AddShoppingListScreen();
        },
      ),

      // Different types of chefs
      GoRoute(
        path: "/pantry_chef",
        name: "pantry_chef",
        builder: (context, state) {
          return PantryChefScreen();
        },
      ),

      GoRoute(
        path: "/master_chef",
        name: "master_chef",
        builder: (context, state) {
          return MasterChefScreen();
        },
      ),

      GoRoute(
        path: "/macro_chef",
        name: "macro_chef",
        builder: (context, state) {
          return MacroChefScreen();
        },
      ),
    ],
  );
}
