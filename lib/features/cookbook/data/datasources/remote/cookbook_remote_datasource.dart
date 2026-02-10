import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/cookbook/data/datasources/cookbook_datasource.dart';
import 'package:yumm_ai/features/cookbook/data/models/cookbook_recipe_model.dart';

class CookbookRemoteDataSource implements ICookbookRemoteDataSource {
  final ApiClient _apiClient;

  CookbookRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<CookbookRecipeModel> addToCookbook({
    required String userId,
    required String recipeId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.addToCookbook,
      data: {'userId': userId, 'recipeId': recipeId},
    );
    if (response.data["success"]) {
      return CookbookRecipeModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );
    }
    throw Exception(response.data['message'] ?? 'Failed to add to cookbook');
  }

  @override
  Future<CookbookRecipeModel> savePrivateRecipe({
    required RecipeModel recipe,
    required String userId,
  }) async {
    final recipeJson = recipe.toJson();
    recipeJson['userId'] = userId;

    final response = await _apiClient.post(
      ApiEndpoints.savePrivateRecipe,
      data: recipeJson,
    );
    if (response.data["success"]) {
      return CookbookRecipeModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );
    }
    throw Exception(
      response.data['message'] ?? 'Failed to save private recipe',
    );
  }

  @override
  Future<List<CookbookRecipeModel>> getUserCookbook(String userId) async {
    final response = await _apiClient.get(ApiEndpoints.getUserCookbook(userId));
    if (response.data["success"]) {
      final data = response.data["data"]["recipes"] as List<dynamic>;
      return CookbookRecipeModel.fromJsonList(data);
    }
    throw Exception(response.data['message'] ?? 'Failed to fetch cookbook');
  }

  @override
  Future<CookbookRecipeModel> getUserRecipe(String userRecipeId) async {
    final response = await _apiClient.get(
      ApiEndpoints.getUserRecipe(userRecipeId),
    );
    if (response.data["success"]) {
      return CookbookRecipeModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );
    }
    throw Exception(response.data['message'] ?? 'Failed to fetch user recipe');
  }

  @override
  Future<CookbookRecipeModel> getUserRecipeByOriginal({
    required String userId,
    required String originalRecipeId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.getUserRecipeByOriginal(userId, originalRecipeId),
    );
    if (response.data["success"]) {
      return CookbookRecipeModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );
    }
    throw Exception(
      response.data['message'] ?? 'Failed to fetch user recipe by original',
    );
  }

  @override
  Future<CookbookRecipeModel> updateUserRecipe(
    CookbookRecipeModel recipe,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateUserRecipe(recipe.userRecipeId),
      data: recipe.toJson(),
    );
    if (response.data["success"]) {
      return CookbookRecipeModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );
    }
    throw Exception(response.data['message'] ?? 'Failed to update user recipe');
  }

  @override
  Future<CookbookRecipeModel> fullUpdateUserRecipe(
    CookbookRecipeModel recipe,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.fullUpdateUserRecipe(recipe.userRecipeId),
      data: recipe.toJson(),
    );
    if (response.data["success"]) {
      return CookbookRecipeModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );
    }
    throw Exception(response.data['message'] ?? 'Failed to update user recipe');
  }

  @override
  Future<bool> removeFromCookbook(String userRecipeId) async {
    final response = await _apiClient.delete(
      ApiEndpoints.removeFromCookbook(userRecipeId),
    );
    if (response.data["success"]) {
      return true;
    }
    throw Exception(
      response.data['message'] ?? 'Failed to remove from cookbook',
    );
  }

  @override
  Future<bool> isRecipeInCookbook({
    required String userId,
    required String originalRecipeId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.isRecipeInCookbook(userId, originalRecipeId),
    );
    if (response.data["success"]) {
      return response.data["data"]["isInCookbook"] as bool;
    }
    throw Exception(
      response.data['message'] ?? 'Failed to check cookbook status',
    );
  }

  @override
  Future<CookbookRecipeModel> resetProgress(String userRecipeId) async {
    final response = await _apiClient.post(
      ApiEndpoints.resetRecipeProgress(userRecipeId),
    );
    if (response.data["success"]) {
      return CookbookRecipeModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );
    }
    throw Exception(response.data['message'] ?? 'Failed to reset progress');
  }
}
