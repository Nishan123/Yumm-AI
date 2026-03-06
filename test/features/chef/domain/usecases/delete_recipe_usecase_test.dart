import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/chef/domain/repositories/recipe_repository.dart';
import 'package:yumm_ai/features/chef/domain/usecases/delete_recipe_usecase.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late DeleteRecipeUsecase usecase;
  late MockRecipeRepository mockRepository;

  setUp(() {
    mockRepository = MockRecipeRepository();
    usecase = DeleteRecipeUsecase(repository: mockRepository);
  });

  const tRecipeId = "test_recipe_id";
  const tParamsCascade = DeleteRecipeParams(recipeId: tRecipeId, cascade: true);
  const tParamsNoCascade = DeleteRecipeParams(
    recipeId: tRecipeId,
    cascade: false,
  );

  test(
    'should call deleteRecipeWithCascade on the repository when cascade is true',
    () async {
      // arrange
      when(
        () => mockRepository.deleteRecipeWithCascade(tRecipeId),
      ).thenAnswer((_) async => true);

      // act
      final result = await usecase(tParamsCascade);

      // assert
      expect(result, const Right(true));
      verify(() => mockRepository.deleteRecipeWithCascade(tRecipeId));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should call deleteRecipe on the repository when cascade is false',
    () async {
      // arrange
      when(
        () => mockRepository.deleteRecipe(tRecipeId),
      ).thenAnswer((_) async => true);

      // act
      final result = await usecase(tParamsNoCascade);

      // assert
      expect(result, const Right(true));
      verify(() => mockRepository.deleteRecipe(tRecipeId));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
