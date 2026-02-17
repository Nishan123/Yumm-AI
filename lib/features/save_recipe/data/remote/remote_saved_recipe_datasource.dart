import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/save_recipe/data/saved_recipe_datasource.dart';

class RemoteSavedRecipeDatasource implements IRemoteSavedRecipeDatasource {
  final ApiClient _apiClient;

  RemoteSavedRecipeDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;
  @override
  Future<List<RecipeModel>> getSavedRecipe({required String uid}) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getSavedRecipe(uid));

      if (response.data["success"] == true) {
        final responseData = response.data["data"];
        if (responseData != null && responseData["recipe"] != null) {
          final data = RecipeModel.fromJsonList(
            (responseData["recipe"] as List).cast<Map<String, dynamic>>(),
          );
          return data;
        }
        return [];
      }
      throw ApiFailure(message: "${response.data["message"]}");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RecipeModel> toggleRecipeLike({required String recipeId}) async {
    final response = await _apiClient.post(ApiEndpoints.toggleSave(recipeId));
    if (response.data["success"]) {
      final data = response.data["data"] as Map<String, dynamic>;
      return RecipeModel.fromJson(data);
    }
    throw ApiFailure(message: response.data["message"]);
  }
}
