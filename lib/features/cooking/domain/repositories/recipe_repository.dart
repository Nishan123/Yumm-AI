import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

abstract class IRecipeRepository {
  Future<Either<Failure, List<RecipeEntity>>> getPublicRecipes();
  Future<Either<Failure, RecipeEntity>> updateRecipe(RecipeEntity recipe);
}
