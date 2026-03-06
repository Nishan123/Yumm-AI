import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/save_recipe/presentation/view_model/save_recipe_view_model.dart';
import 'package:yumm_ai/features/save_recipe/presentation/state/save_recipe_state.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/recipe_provider.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/top_recipe_provider.dart';
import 'package:yumm_ai/features/dashboard/presentation/pages/main_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCookbookViewModel extends CookbookViewModel {
  @override
  CookbookState build() => const CookbookState();
}

class MockSaveRecipeViewModel extends SaveRecipeViewModel {
  @override
  SaveRecipeState build() => SaveRecipeState.initial();
}

class MockPublicRecipesNotifier extends PublicRecipesNotifier {
  @override
  Future<List<RecipeEntity>> build() async => [];
}

class MockTopPublicRecipesNotifier extends TopPublicRecipesNotifier {
  @override
  Future<List<RecipeEntity>> build() async => [];
  @override
  bool get canLoadMore => false;
}

void main() {
  testWidgets(
    'MainScreen scaffold renders without crashing',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final mockAuthRepo = MockAuthRepository();

      const testUser = UserEntity(
        uid: 'u1',
        email: 'test@test.com',
        fullName: 'Test User',
        authProvider: 'emailPassword',
        profilePic: '',
      );
      when(
        () => mockAuthRepo.getCurrentUserFromServer(),
      ).thenAnswer((_) async => const Right(testUser));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            authRepositoryProvider.overrideWithValue(mockAuthRepo),
            cookbookViewModelProvider.overrideWith(
              () => MockCookbookViewModel(),
            ),
            saveRecipeViewModelProvider.overrideWith(
              () => MockSaveRecipeViewModel(),
            ),
            publicRecipesProvider.overrideWith(
              () => MockPublicRecipesNotifier(),
            ),
            topPublicRecipesProvider.overrideWith(
              () => MockTopPublicRecipesNotifier(),
            ),
          ],
          child: const MaterialApp(home: MainScreen()),
        ),
      );
      // Pump one frame to build the widget tree
      await tester.pump();

      expect(find.byType(Scaffold), findsWidgets);
    },
    timeout: const Timeout(Duration(seconds: 10)),
  );
}
