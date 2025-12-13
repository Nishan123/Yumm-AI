import 'package:go_router/go_router.dart';
import 'package:yumm_ai/screens/auth/login_screen.dart';
import 'package:yumm_ai/screens/auth/signup_screen.dart';
import 'package:yumm_ai/screens/kitchen_tools/kitchen_tools_screen.dart';
import 'package:yumm_ai/screens/main/main_screen.dart';
import 'package:yumm_ai/screens/pantry_chef/pantry_chef_screen.dart';
import 'package:yumm_ai/screens/pantry_inventory/pantry_inventory_screen.dart';
import 'package:yumm_ai/screens/saved_recipe/saved_recipe_screen.dart';
import 'package:yumm_ai/screens/scanner/scanner_screen.dart';
import 'package:yumm_ai/screens/shopping_list/shopping_list_screen.dart';

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
        path: "/pantryChef",
        name: "pantryChef",
        builder: (context, state) {
          return PantryChefScreen();
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
    ],
  );
}
