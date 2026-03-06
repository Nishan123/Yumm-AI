import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_recipe_images_usecase.dart';
import 'package:yumm_ai/features/chef/domain/usecases/save_recipe_usecase.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/base_chef_view_model.dart';

class MockGenerateRecipeImagesUsecase extends Mock
    implements GenerateRecipeImagesUsecase {}

class MockSaveRecipeUsecase extends Mock implements SaveRecipeUsecase {}

class TestChefViewModel extends BaseChefViewModel {
  @override
  ChefState build() {
    initBaseUsecases();
    return const ChefState();
  }
}

final testChefViewModelProvider =
    NotifierProvider<TestChefViewModel, ChefState>(() => TestChefViewModel());

class FakeGenerateRecipeImagesParams extends Fake
    implements GenerateRecipeImagesParams {}

class FakeSaveRecipeParams extends Fake implements SaveRecipeParams {}

class FakeRecipeEntity extends Fake implements RecipeEntity {}

void main() {
  late ProviderContainer container;
  late MockGenerateRecipeImagesUsecase mockGenerateRecipeImagesUsecase;
  late MockSaveRecipeUsecase mockSaveRecipeUsecase;

  setUpAll(() {
    registerFallbackValue(FakeGenerateRecipeImagesParams());
    registerFallbackValue(FakeSaveRecipeParams());
  });

  setUp(() {
    mockGenerateRecipeImagesUsecase = MockGenerateRecipeImagesUsecase();
    mockSaveRecipeUsecase = MockSaveRecipeUsecase();

    container = ProviderContainer(
      overrides: [
        generateRecipeImagesUsecaseProvider.overrideWithValue(
          mockGenerateRecipeImagesUsecase,
        ),
        saveRecipeUsecaseProvider.overrideWithValue(mockSaveRecipeUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('generateImagesAndSave success updates state to success', () async {
    final tRecipe = RecipeModel(
      recipeId: '1',
      generatedBy: 'system',
      recipeName: 'Test',
      description: 'Desc',
      ingredients: [],
      steps: [],
      initialPreparation: [],
      kitchenTools: [],
      experienceLevel: 'beginner',
      estCookingTime: '10 mins',
      mealType: 'dinner',
      cuisine: 'italian',
      calorie: 100,
      images: [],
      servings: 2,
      likes: [],
    );

    when(
      () => mockGenerateRecipeImagesUsecase.call(any()),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => mockSaveRecipeUsecase.call(any()),
    ).thenAnswer((_) async => Right(tRecipe.toEntity()));

    final viewModel = container.read(testChefViewModelProvider.notifier);

    await viewModel.generateImagesAndSave(
      tempRecipe: tRecipe,
      currentUserId: 'user1',
      isPublic: true,
    );

    final state = container.read(testChefViewModelProvider);
    expect(state.status, ChefStatus.success);
  });
}
