import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

final recipeRemoteDataSourceProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return RecipeRemoteDataSource(apiClient: apiClient);
});

abstract class IRecipeRemoteDataSource {
  Future<({List<RecipeModel> recipes, int total, int page, int totalPages})>
  getPublicRecipes({int page = 1, int limit = 10});
  Future<RecipeModel> updateRecipe(RecipeModel recipe);
}

class RecipeRemoteDataSource implements IRecipeRemoteDataSource {
  final ApiClient _apiClient;

  RecipeRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<({List<RecipeModel> recipes, int total, int page, int totalPages})>
  getPublicRecipes({int page = 1, int limit = 10}) async {
    final response = await _apiClient.get(
      "${ApiEndpoints.getPublicRecipes}?page=$page&limit=$limit",
    );
    if (response.data["success"]) {
      final data = response.data["data"];
      final recipesData = data["recipe"] as List<dynamic>;
      final pagination = data["pagination"];

      final recipes = recipesData
          .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return (
        recipes: recipes,
        total: pagination["total"] as int,
        page: pagination["page"] as int,
        totalPages: pagination["totalPages"] as int,
      );
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
