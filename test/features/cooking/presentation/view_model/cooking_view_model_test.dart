import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/domain/usecases/update_recipe_usecase.dart';
import 'package:yumm_ai/features/cooking/presentation/view_model/cooking_view_model.dart';

class MockUpdateRecipeUseCase extends Mock implements UpdateRecipeUseCase {}

class FakeRecipeEntity extends Fake implements RecipeEntity {}

void main() {
  late ProviderContainer container;
  late MockUpdateRecipeUseCase mockUpdateRecipeUseCase;

  setUpAll(() {
    registerFallbackValue(FakeRecipeEntity());
  });

  setUp(() {
    mockUpdateRecipeUseCase = MockUpdateRecipeUseCase();

    container = ProviderContainer(
      overrides: [
        updateRecipeUseCaseProvider.overrideWithValue(mockUpdateRecipeUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('updateRecipe success updates state data to null', () async {
    when(
      () => mockUpdateRecipeUseCase.call(any()),
    ).thenAnswer((_) async => Right(FakeRecipeEntity()));

    final viewModel = container.read(cookingViewModelProvider.notifier);
    await viewModel.updateRecipe(FakeRecipeEntity());

    final state = container.read(cookingViewModelProvider);
    expect(state, const AsyncData<void>(null));
  });
}
