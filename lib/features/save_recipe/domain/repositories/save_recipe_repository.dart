import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

abstract interface class ISavedRecipeRepository {
  Future<Either<Failure, RecipeEntity>> toggleSaveRecipe(String recipeId);
  Future<Either<Failure, List<RecipeEntity>>> getSavedRecipe(String uid);
}
