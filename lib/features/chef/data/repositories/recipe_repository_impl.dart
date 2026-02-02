import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/data/datasource/recipe_datasource.dart';
import 'package:yumm_ai/features/chef/data/datasource/remote/recipe_remote_datasource.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/chef/domain/repositories/recipe_repository.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepositoryImpl(ref.read(recipeRemoteDataSourceProvider));
});

class RecipeRepositoryImpl implements RecipeRepository {
  final IRecipeRemoteDataSource _remoteDataSource;

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

  @override
  Future<RecipeEntity> updateRecipe(RecipeModel recipe) async {
    try {
      final updatedModel = await _remoteDataSource.updateRecipe(recipe);
      return updatedModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteRecipe(String recipeId) async {
    try {
      return await _remoteDataSource.deleteRecipe(recipeId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteRecipeWithCascade(String recipeId) async {
    try {
      return await _remoteDataSource.deleteRecipeWithCascade(recipeId);
    } catch (e) {
      rethrow;
    }
  }
}
