import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/food_pref/domain/entity/food_pref_entity.dart';

abstract interface class IFoodPrefRepository {
  Future<Either<Failure, FoodPrefEntity>> addfoodPreferences(
    FoodPrefEntity foodPref,
  );
  Future<Either<Failure, FoodPrefEntity>> getUserFoodPreferences(String uid);
  Future<Either<Failure, FoodPrefEntity>> updateFoodPreferences(String prefId, FoodPrefEntity foodPref);
}
