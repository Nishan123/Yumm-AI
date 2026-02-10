import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';

abstract class ICookbookRepository {
  Future<Either<Failure, CookbookRecipeEntity>> addToCookbook({
    required String userId,
    required String recipeId,
  });

  Future<Either<Failure, CookbookRecipeEntity>> savePrivateRecipe({
    required RecipeModel recipe,
    required String userId,
  });

  Future<Either<Failure, List<CookbookRecipeEntity>>> getUserCookbook(
    String userId,
  );

  Future<Either<Failure, CookbookRecipeEntity>> getUserRecipe(
    String userRecipeId,
  );

  Future<Either<Failure, CookbookRecipeEntity>> getUserRecipeByOriginal({
    required String userId,
    required String originalRecipeId,
  });

  Future<Either<Failure, CookbookRecipeEntity>> updateUserRecipe(
    CookbookRecipeEntity recipe,
  );

  Future<Either<Failure, CookbookRecipeEntity>> fullUpdateUserRecipe(
    CookbookRecipeEntity recipe,
  );

  Future<Either<Failure, bool>> removeFromCookbook(String userRecipeId);

  Future<Either<Failure, bool>> isRecipeInCookbook({
    required String userId,
    required String originalRecipeId,
  });

  Future<Either<Failure, CookbookRecipeEntity>> resetProgress(
    String userRecipeId,
  );
}
