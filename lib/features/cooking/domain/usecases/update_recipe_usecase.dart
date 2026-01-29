import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/data/repositories/recipe_repository_impl.dart';
import 'package:yumm_ai/features/cooking/domain/repositories/recipe_repository.dart';

final updateRecipeUseCaseProvider = Provider((ref) {
  final repository = ref.read(recipeRepositoryProvider);
  return UpdateRecipeUseCase(repository);
});

class UpdateRecipeUseCase {
  final IRecipeRepository repository;

  UpdateRecipeUseCase(this.repository);

  Future<Either<Failure, RecipeEntity>> call(RecipeEntity recipe) async {
    return await repository.updateRecipe(recipe);
  }
}
