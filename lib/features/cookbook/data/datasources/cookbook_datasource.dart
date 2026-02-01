import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/cookbook/data/datasources/remote/cookbook_remote_datasource.dart';
import 'package:yumm_ai/features/cookbook/data/models/cookbook_recipe_model.dart';

final cookbookRemoteDataSourceProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return CookbookRemoteDataSource(apiClient: apiClient);
});

abstract class ICookbookRemoteDataSource {
  Future<CookbookRecipeModel> addToCookbook({
    required String userId,
    required String recipeId,
  });

  Future<CookbookRecipeModel> savePrivateRecipe({
    required RecipeModel recipe,
    required String userId,
  });

  Future<List<CookbookRecipeModel>> getUserCookbook(String userId);

  Future<CookbookRecipeModel> getUserRecipe(String userRecipeId);

  Future<CookbookRecipeModel> getUserRecipeByOriginal({
    required String userId,
    required String originalRecipeId,
  });

  Future<CookbookRecipeModel> updateUserRecipe(CookbookRecipeModel recipe);

  Future<bool> removeFromCookbook(String userRecipeId);

  Future<bool> isRecipeInCookbook({
    required String userId,
    required String originalRecipeId,
  });

  Future<CookbookRecipeModel> resetProgress(String userRecipeId);
}
