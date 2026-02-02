import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';

/// Repository interface for cookbook operations.
/// Defines the contract for managing user-specific recipe instances.
abstract class ICookbookRepository {
  /// Add a recipe to user's cookbook
  /// Creates a user-specific copy of the recipe for independent progress tracking
  Future<Either<Failure, CookbookRecipeEntity>> addToCookbook({
    required String userId,
    required String recipeId,
  });

  /// Save a private recipe directly to user's cookbook
  /// Private recipes are NOT saved to the public Recipe collection
  Future<Either<Failure, CookbookRecipeEntity>> savePrivateRecipe({
    required RecipeModel recipe,
    required String userId,
  });

  /// Get all recipes in user's cookbook
  Future<Either<Failure, List<CookbookRecipeEntity>>> getUserCookbook(
    String userId,
  );

  /// Get a specific user recipe by its ID
  Future<Either<Failure, CookbookRecipeEntity>> getUserRecipe(
    String userRecipeId,
  );

  /// Get user's copy of a recipe by the original recipe ID
  Future<Either<Failure, CookbookRecipeEntity>> getUserRecipeByOriginal({
    required String userId,
    required String originalRecipeId,
  });

  /// Update user's recipe progress (check/uncheck ingredients, instructions, etc.)
  Future<Either<Failure, CookbookRecipeEntity>> updateUserRecipe(
    CookbookRecipeEntity recipe,
  );

  /// Full update of user's recipe content (not just progress)
  Future<Either<Failure, CookbookRecipeEntity>> fullUpdateUserRecipe(
    CookbookRecipeEntity recipe,
  );

  /// Remove a recipe from user's cookbook
  Future<Either<Failure, bool>> removeFromCookbook(String userRecipeId);

  /// Check if a recipe is in user's cookbook
  Future<Either<Failure, bool>> isRecipeInCookbook({
    required String userId,
    required String originalRecipeId,
  });

  /// Reset progress for a user's recipe (uncheck all items)
  Future<Either<Failure, CookbookRecipeEntity>> resetProgress(
    String userRecipeId,
  );
}
