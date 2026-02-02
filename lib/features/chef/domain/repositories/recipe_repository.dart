import 'package:flutter/foundation.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

abstract class RecipeRepository {
  Future<RecipeEntity> saveRecipe(RecipeModel recipe);

  Future<List<String>> uploadRecipeImages({
    required String recipeId,
    required List<Uint8List> images,
  });

  Future<RecipeEntity> updateRecipe(RecipeModel recipe);

  Future<bool> deleteRecipe(String recipeId);

  Future<bool> deleteRecipeWithCascade(String recipeId);
}
