import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

final recipeRemoteDataSourceProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return RecipeRemoteDataSource(apiClient: apiClient);
});

abstract class IRecipeRemoteDataSource {
  Future<List<RecipeModel>> getPublicRecipes();
  Future<RecipeModel> updateRecipe(RecipeModel recipe);
}

class RecipeRemoteDataSource implements IRecipeRemoteDataSource {
  final ApiClient _apiClient;

  RecipeRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;



  @override
  Future<List<RecipeModel>> getPublicRecipes() async {
    final response = await _apiClient.get(ApiEndpoints.getPublicRecipes);
    if (response.data["success"]) {
      final recipesData = response.data["data"] as List<dynamic>;
      return recipesData
          .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(
      response.data['message'] ?? 'Failed to fetch public recipes',
    );
  }

  @override
  Future<RecipeModel> updateRecipe(RecipeModel recipe) async {
    final response = await _apiClient.put(
      "${ApiEndpoints.updateRecipe}/${recipe.recipeId}",
      data: recipe.toJson(),
    );
    if (response.data["success"]) {
      return RecipeModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );
    }
    throw Exception(response.data['message'] ?? 'Failed to update recipe');
  }
}
