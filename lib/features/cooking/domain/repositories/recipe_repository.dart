import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

abstract class IRecipeRepository {
  Future<
    Either<
      Failure,
      ({List<RecipeEntity> recipes, int total, int page, int totalPages})
    >
  >
  getTopPublicRecipes({int page = 1, int limit = 10});
  Future<
    Either<
      Failure,
      ({List<RecipeEntity> recipes, int total, int page, int totalPages})
    >
  >
  getPublicRecipes({int page = 1, int limit = 10});
  Future<Either<Failure, RecipeEntity>> updateRecipe(RecipeEntity recipe);
}
