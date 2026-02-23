import 'dart:typed_data';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/features/auth/presentation/pages/change_password_screen.dart';
import 'package:yumm_ai/features/bug_report/presentation/pages/report_bug_screen.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/auth/presentation/pages/login_screen.dart';
import 'package:yumm_ai/features/auth/presentation/pages/signup_screen.dart';
import 'package:yumm_ai/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:yumm_ai/features/auth/presentation/pages/splash_screen.dart';
import 'package:yumm_ai/features/chef/presentation/pages/chefs_screen.dart';
import 'package:yumm_ai/features/chef/presentation/pages/macro_chef_screen.dart';
import 'package:yumm_ai/features/chef/presentation/pages/master_chef_screen.dart';
import 'package:yumm_ai/features/chef/presentation/pages/pantry_chef_screen.dart';
import 'package:yumm_ai/features/chef/presentation/pages/recipe_generation_loading_screen.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/presentation/pages/edit_recipe_screen.dart';
import 'package:yumm_ai/features/cooking/presentation/pages/cooking_screen.dart';
import 'package:yumm_ai/features/dashboard/presentation/pages/main_screen.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/pages/kitchen_tools_screen.dart';
import 'package:yumm_ai/features/pantry_inventory/presentation/pages/pantry_inventory_screen.dart';
import 'package:yumm_ai/features/profile/presentation/pages/delete_profile_screen.dart';
import 'package:yumm_ai/features/profile/presentation/pages/profile_screen.dart';
import 'package:yumm_ai/features/save_recipe/presentation/pages/saved_recipes_screen.dart';
import 'package:yumm_ai/features/scanner/presentation/pages/scanner_screen.dart';
import 'package:yumm_ai/features/search/presentation/pages/search_results_screen.dart';
import 'package:yumm_ai/features/settings/presentation/pages/app_theme_screen.dart';
import 'package:yumm_ai/features/settings/presentation/pages/setting_screen.dart';
import 'package:yumm_ai/features/shopping_list/presentation/pages/add_shopping_list_screen.dart';
import 'package:yumm_ai/features/shopping_list/presentation/pages/shopping_list_screen.dart';
import 'package:yumm_ai/features/subscription/presentation/pages/available_plans_screen.dart';

import 'package:yumm_ai/core/utils/navigator_key.dart';

class AppRoutes {
  AppRoutes();
  final GoRouter appRoutes = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: "/main",
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
        path: "/report_bug",
        name: "report_bug",
        builder: (context, state) {
          final screenshot = state.extra as Uint8List?;
          return ReportBugScreen(screenshot: screenshot);
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
        path: "/app_theme",
        name: "app_theme",
        builder: (context, state) {
          return AppThemeScreen();
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
        path: "/change_password",
        name: "change_password",
        builder: (context, state) {
          return ChangePasswordScreen();
        },
      ),
      GoRoute(
        path: "/delete_profile",
        name: "delete_profile",
        builder: (context, state) {
          return DeleteProfileScreen();
        },
      ),
      GoRoute(
        path: "/cooking",
        name: "cooking",
        builder: (context, state) {
          final recipe = state.extra as RecipeEntity;
          return CookingScreen(recipe: recipe);
        },
      ),
      GoRoute(
        path: "/edit_recipe",
        name: "edit_recipe",
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            final recipe = extra['recipe'] as RecipeEntity;
            final isOwner = extra['isOwner'] as bool? ?? false;
            final userRecipeId = extra['userRecipeId'] as String?;
            final cookbookRecipe =
                extra['cookbookRecipe'] as CookbookRecipeEntity?;
            return EditRecipeScreen(
              params: EditRecipeParams(
                recipe: recipe,
                isOwner: isOwner,
                userRecipeId: userRecipeId,
                cookbookRecipe: cookbookRecipe,
              ),
            );
          }
          return const EditRecipeScreen();
        },
      ),
      GoRoute(
        path: "/generating_recipe",
        name: "generating_recipe",
        builder: (context, state) {
          return RecipeGenerationLoadingScreen();
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
        path: "/forgot_password",
        name: "forgot_password",
        builder: (context, state) {
          return const ForgotPasswordScreen();
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
        path: "/saved_recipe",
        name: "saved_recipe",
        builder: (context, state) {
          return const SavedRecipesScreen();
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
        path: "/search_results",
        name: "search_results",
        builder: (context, state) {
          return SearchResultsScreen();
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
