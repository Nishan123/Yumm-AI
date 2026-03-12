import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_recipe_images_usecase.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_scan_recipe_fridge.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_scan_recipe_receipt.dart';
import 'package:yumm_ai/features/chef/domain/usecases/save_recipe_usecase.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/scanner/presentation/view_model/scanner_chef_view_model.dart';

class MockGenerateScanRecipeFridge extends Mock
    implements GenerateScanRecipeFridge {}

class MockGenerateScanRecipeReceipt extends Mock
    implements GenerateScanRecipeReceipt {}

class MockGenerateRecipeImagesUsecase extends Mock
    implements GenerateRecipeImagesUsecase {}

class MockSaveRecipeUsecase extends Mock implements SaveRecipeUsecase {}

class FakeGenerateScanRecipeFridgeParams extends Fake
    implements GenerateScanRecipeFridgeParams {}

class FakeGenerateRecipeImagesParams extends Fake
    implements GenerateRecipeImagesParams {}

class FakeSaveRecipeParams extends Fake implements SaveRecipeParams {}

class FakeXFile extends Fake implements XFile {}

class FakeRecipeEntity extends Fake implements RecipeEntity {}

void main() {
  late ProviderContainer container;
  late MockGenerateScanRecipeFridge mockGenerateScanRecipeFridge;
  late MockGenerateScanRecipeReceipt mockGenerateScanRecipeReceipt;
  late MockGenerateRecipeImagesUsecase mockGenerateRecipeImagesUsecase;
  late MockSaveRecipeUsecase mockSaveRecipeUsecase;

  setUpAll(() {
    registerFallbackValue(FakeGenerateScanRecipeFridgeParams());
    registerFallbackValue(FakeGenerateRecipeImagesParams());
    registerFallbackValue(FakeSaveRecipeParams());
  });

  setUp(() {
    mockGenerateScanRecipeFridge = MockGenerateScanRecipeFridge();
    mockGenerateScanRecipeReceipt = MockGenerateScanRecipeReceipt();
    mockGenerateRecipeImagesUsecase = MockGenerateRecipeImagesUsecase();
    mockSaveRecipeUsecase = MockSaveRecipeUsecase();

    container = ProviderContainer(
      overrides: [
        generateScanRecipeFridgeUsecaseProvider.overrideWithValue(
          mockGenerateScanRecipeFridge,
        ),
        generateScanRecipeReceiptUsecaseProvider.overrideWithValue(
          mockGenerateScanRecipeReceipt,
        ),
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

  test('generateRecipeFromFridge success updates state', () async {
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
      () => mockGenerateScanRecipeFridge.call(any()),
    ).thenAnswer((_) async => Right(tRecipe));
    when(
      () => mockGenerateRecipeImagesUsecase.call(any()),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => mockSaveRecipeUsecase.call(any()),
    ).thenAnswer((_) async => Right(tRecipe.toEntity()));

    final viewModel = container.read(scannerChefViewModelProvider.notifier);

    await viewModel.generateRecipeFromFridge(
      image: FakeXFile(),
      currentUserId: 'user1',
      isPublic: true,
      mealType: 'Dinner',
    );

    final state = container.read(scannerChefViewModelProvider);
    expect(state.status, ChefStatus.success);
  });
}
