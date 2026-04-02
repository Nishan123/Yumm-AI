import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/connectivity/network_info.dart';
import 'package:yumm_ai/features/food_pref/data/datasource/food_pref_datasource.dart';
import 'package:yumm_ai/features/food_pref/data/datasource/remote/remote_food_pref_datasource.dart';
import 'package:yumm_ai/features/food_pref/data/model/food_pref_api_model.dart';
import 'package:yumm_ai/features/food_pref/domain/entity/food_pref_entity.dart';
import 'package:yumm_ai/features/food_pref/domain/repositories/food_pref_repository.dart';

final foodPrefRepositoryProvider = Provider((ref) {
  return FoodPrefRepository(
    networkInfo: ref.read(networkInfoProvider),
    remoteFoodPrefDatasource: ref.read(remoteFoodPrefDatasourceProvider),
  );
});

class FoodPrefRepository implements IFoodPrefRepository {
  final NetworkInfo _networkInfo;
  final IRemoteFoodPrefDatasource _remoteFoodPrefDatasource;

  FoodPrefRepository({
    required NetworkInfo networkInfo,
    required IRemoteFoodPrefDatasource remoteFoodPrefDatasource,
  }) : _networkInfo = networkInfo,
       _remoteFoodPrefDatasource = remoteFoodPrefDatasource;
  @override
  Future<Either<Failure, FoodPrefEntity>> addfoodPreferences(
    FoodPrefEntity foodPref,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final foodPrefModel = FoodPrefApiModel.fromEntity(foodPref);
        _remoteFoodPrefDatasource.saveFoodPref(foodPrefModel);
        return Right(foodPrefModel.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(GeneralFailure("No internet connection"));
    }
  }

  @override
  Future<Either<Failure, FoodPrefEntity>> getUserFoodPreferences(
    String uid,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteFoodPrefDatasource.getUserFoodPref(uid);
        if (model != null) {
          return Right(model.toEntity());
        } else {
          return Left(GeneralFailure("Food preferences not found"));
        }
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(GeneralFailure("No internet connection"));
    }
  }

  @override
  Future<Either<Failure, FoodPrefEntity>> updateFoodPreferences(
    String prefId,
    FoodPrefEntity foodPref,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final foodPrefModel = FoodPrefApiModel.fromEntity(foodPref);
        final result = await _remoteFoodPrefDatasource.updateFoodPref(
          prefId,
          foodPrefModel,
        );
        if (result != null) {
          return Right(result.toEntity());
        } else {
          return Left(GeneralFailure("Failed to update food preferences"));
        }
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(GeneralFailure("No internet connection"));
    }
  }
}
