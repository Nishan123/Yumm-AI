import 'dart:typed_data';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

abstract interface class IRecipeRemoteDataSource {
  Future<RecipeModel> saveRecipe(RecipeModel recipe);
  Future<List<String>> uploadRecipeImages(
    String recipeId,
    List<Uint8List> images,
  );
  Future<RecipeModel> updateRecipe(RecipeModel recipe);
  Future<bool> deleteRecipe(String recipeId);
  Future<bool> deleteRecipeWithCascade(String recipeId);
}
