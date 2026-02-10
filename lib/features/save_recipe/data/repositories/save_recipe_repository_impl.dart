import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/save_recipe/data/remote/remote_saved_recipe_datasource.dart';
import 'package:yumm_ai/features/save_recipe/data/saved_recipe_datasource.dart';
import 'package:yumm_ai/features/save_recipe/domain/repositories/save_recipe_repository.dart';

final savedRecipeRepositoryProvider = Provider<ISavedRecipeRepository>((ref) {
  return SavedRecipeRepository(
    remoteDatasource: ref.read(remoteSavedRecipeDatasourceProvider),
  );
});

final remoteSavedRecipeDatasourceProvider = Provider((ref) {
  return RemoteSavedRecipeDatasource(apiClient: ref.read(apiClientProvider));
});

class SavedRecipeRepository implements ISavedRecipeRepository {
  final IRemoteSavedRecipeDatasource _remoteDatasource;

  SavedRecipeRepository({
    required IRemoteSavedRecipeDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<RecipeEntity>>> getSavedRecipe(String uid) async {
    try {
      final result = await _remoteDatasource.getSavedRecipe(uid: uid);
      return Right(result.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message ?? "Unknown Dio Error"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeEntity>> toggleSaveRecipe(
    String recipeId,
  ) async {
    try {
      final result = await _remoteDatasource.toggleRecipeLike(
        recipeId: recipeId,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message ?? "Unknown Dio Error"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
