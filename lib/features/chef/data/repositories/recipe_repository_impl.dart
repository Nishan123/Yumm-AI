import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/features/chef/data/datasource/recipe_remote_datasource.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/chef/domain/repositories/recipe_repository.dart';

// Providers
final recipeRemoteDataSourceProvider = Provider<RecipeRemoteDataSource>((ref) {
  return RecipeRemoteDataSourceImpl(ref.read(apiClientProvider));
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepositoryImpl(ref.read(recipeRemoteDataSourceProvider));
});

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource _remoteDataSource;

  RecipeRepositoryImpl(this._remoteDataSource);

  @override
  Future<RecipeEntity> saveRecipe(RecipeModel recipe) async {
    try {
      final savedModel = await _remoteDataSource.saveRecipe(recipe);
      return savedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> uploadRecipeImages({
    required String recipeId,
    required List<Uint8List> images,
  }) async {
    try {
      if (images.isEmpty) return [];
      return await _remoteDataSource.uploadRecipeImages(recipeId, images);
    } catch (e) {
      rethrow;
    }
  }
}
