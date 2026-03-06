import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/save_recipe/domain/usecases/get_saved_recipes_usecase.dart';
import 'package:yumm_ai/features/save_recipe/domain/usecases/toggle_save_recipe_usecase.dart';
import 'package:yumm_ai/features/save_recipe/presentation/view_model/save_recipe_view_model.dart';

class MockToggleSaveRecipeUsecase extends Mock
    implements ToggleSaveRecipeUsecase {}

class MockGetSavedRecipesUsecase extends Mock
    implements GetSavedRecipesUsecase {}

class FakeGetSavedRecipesParams extends Fake implements GetSavedRecipesParams {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ProviderContainer container;
  late MockToggleSaveRecipeUsecase mockToggleSaveRecipeUsecase;
  late MockGetSavedRecipesUsecase mockGetSavedRecipesUsecase;
  late MockAuthRepository mockAuthRepository;

  final testUser = const UserEntity(
    uid: "user_1",
    email: "test@test.com",
    fullName: "Test User",
    authProvider: "email",
  );

  setUpAll(() {
    registerFallbackValue(FakeGetSavedRecipesParams());
  });

  setUp(() {
    mockToggleSaveRecipeUsecase = MockToggleSaveRecipeUsecase();
    mockGetSavedRecipesUsecase = MockGetSavedRecipesUsecase();
    mockAuthRepository = MockAuthRepository();

    when(
      () => mockGetSavedRecipesUsecase.call(any()),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => mockAuthRepository.getCurrentUserFromServer(),
    ).thenAnswer((_) async => Right(testUser));

    container = ProviderContainer(
      overrides: [
        toggleSaveRecipeUsecaseProvider.overrideWithValue(
          mockToggleSaveRecipeUsecase,
        ),
        getSavedRecipesUsecaseProvider.overrideWithValue(
          mockGetSavedRecipesUsecase,
        ),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('getSavedRecipes success updates state with recipes', () async {
    // Wait for the microtask to finish first since it's fired on build
    await Future.microtask(() {});

    // Wait for currentUserProvider to finish imitating the fetch
    await container.read(currentUserProvider.future);

    final viewModel = container.read(saveRecipeViewModelProvider.notifier);
    // Initial fetch might have fired, we call it again properly
    await viewModel.getSavedRecipes();

    final state = container.read(saveRecipeViewModelProvider);
    expect(state.isLoading, false);
    expect(state.savedRecipes, isEmpty);
  });
}
