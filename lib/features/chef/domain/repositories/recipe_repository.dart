import 'package:flutter/foundation.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

abstract class RecipeRepository {
  Future<RecipeEntity> saveRecipe(RecipeModel recipe);

  Future<List<String>> uploadRecipeImages({
    required String recipeId,
    required List<Uint8List> images,
  });

  // Optional: If we want to expose generation via repository, but it's a service.
  // We can keep it simple: Repository handles data persistence.
  // Generation service handles AI. ViewModel coordinates.
}
