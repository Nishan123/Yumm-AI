import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/connectivity/network_info.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

import 'package:yumm_ai/features/cooking/data/datasource/remote/recipe_remote_datasource.dart';
import 'package:yumm_ai/features/cooking/domain/repositories/recipe_repository.dart';

final recipeRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.read(recipeRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return RecipeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class RecipeRepositoryImpl implements IRecipeRepository {
  final IRecipeRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  RecipeRepositoryImpl({
    required IRecipeRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllRecipes();
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: "$e"));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<RecipeEntity>>> getPublicRecipes() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getPublicRecipes();
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: "$e"));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, RecipeEntity>> updateRecipe(
    RecipeEntity recipe,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = RecipeModel.fromEntity(recipe);
        final result = await _remoteDataSource.updateRecipe(model);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: "$e"));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }
}
