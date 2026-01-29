import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/connectivity/network_info.dart';
import 'package:yumm_ai/features/cookbook/data/datasources/cookbook_remote_datasource.dart';
import 'package:yumm_ai/features/cookbook/data/models/cookbook_recipe_model.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/repositories/cookbook_repository.dart';

final cookbookRepositoryProvider = Provider<ICookbookRepository>((ref) {
  final remoteDataSource = ref.watch(cookbookRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return CookbookRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class CookbookRepositoryImpl implements ICookbookRepository {
  final CookbookRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CookbookRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CookbookRecipeEntity>> addToCookbook({
    required String userId,
    required String recipeId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addToCookbook(
          userId: userId,
          recipeId: recipeId,
        );
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<CookbookRecipeEntity>>> getUserCookbook(
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUserCookbook(userId);
        return Right(result.map((e) => e.toEntity()).toList());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, CookbookRecipeEntity>> getUserRecipe(
    String userRecipeId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUserRecipe(userRecipeId);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, CookbookRecipeEntity>> getUserRecipeByOriginal({
    required String userId,
    required String originalRecipeId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUserRecipeByOriginal(
          userId: userId,
          originalRecipeId: originalRecipeId,
        );
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, CookbookRecipeEntity>> updateUserRecipe(
    CookbookRecipeEntity recipe,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final model = CookbookRecipeModel.fromEntity(recipe);
        final result = await remoteDataSource.updateUserRecipe(model);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromCookbook(String userRecipeId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.removeFromCookbook(userRecipeId);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, bool>> isRecipeInCookbook({
    required String userId,
    required String originalRecipeId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.isRecipeInCookbook(
          userId: userId,
          originalRecipeId: originalRecipeId,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, CookbookRecipeEntity>> resetProgress(
    String userRecipeId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.resetProgress(userRecipeId);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }
}
