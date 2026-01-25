import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<RecipeModel> saveRecipe(RecipeModel recipe);
  Future<List<String>> uploadRecipeImages(
    String recipeId,
    List<Uint8List> images,
  );
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final ApiClient _apiClient;

  RecipeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<RecipeModel> saveRecipe(RecipeModel recipe) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.saveRecipe,
        data: recipe.toJson(),
      );

      // key might be 'data' or direct based on response util
      // Server sends: sendSuccess(res, recipe, 201) -> { success: true, data: recipe, ... }
      final data = response.data['data'];
      return RecipeModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> uploadRecipeImages(
    String recipeId,
    List<Uint8List> images,
  ) async {
    try {
      final formData = FormData();

      for (int i = 0; i < images.length; i++) {
        formData.files.add(
          MapEntry(
            'images',
            MultipartFile.fromBytes(images[i], filename: 'recipe_image_$i.png'),
          ),
        );
      }

      final response = await _apiClient.uploadFile(
        ApiEndpoints.uploadRecipeImages(recipeId),
        formData: formData,
      );

      // Server sends: { success: true, data: { images: [url1, url2] } }
      final data = response.data['data'];
      return List<String>.from(data['images']);
    } catch (e) {
      rethrow;
    }
  }
}
