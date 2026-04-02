import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/food_pref/data/repositories/food_pref_repository.dart';
import 'package:yumm_ai/features/food_pref/domain/entity/food_pref_entity.dart';
import 'package:yumm_ai/features/food_pref/domain/repositories/food_pref_repository.dart';

final updateFoodPrefUsecaseProvider = Provider((ref) {
  return UpdateFoodPrefUsecase(
    foodPrefRepository: ref.read(foodPrefRepositoryProvider),
  );
});

class UpdateFoodPrefUsecaseParam extends Equatable {
  final FoodPrefEntity foodPref;
  final String prefId;
  const UpdateFoodPrefUsecaseParam({
    required this.foodPref,
    required this.prefId,
  });

  @override
  List<Object?> get props => [prefId, foodPref];
}

class UpdateFoodPrefUsecase
    implements UsecaseWithParms<FoodPrefEntity, UpdateFoodPrefUsecaseParam> {
  final IFoodPrefRepository _foodPrefRepository;
  UpdateFoodPrefUsecase({required IFoodPrefRepository foodPrefRepository})
    : _foodPrefRepository = foodPrefRepository;
  @override
  Future<Either<Failure, FoodPrefEntity>> call(
    UpdateFoodPrefUsecaseParam params,
  ) {
    return _foodPrefRepository.updateFoodPreferences(
      params.prefId,
      params.foodPref,
    );
  }
}
