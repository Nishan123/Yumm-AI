import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/food_pref/data/repositories/food_pref_repository.dart';
import 'package:yumm_ai/features/food_pref/domain/entity/food_pref_entity.dart';
import 'package:yumm_ai/features/food_pref/domain/repositories/food_pref_repository.dart';

final saveFoodPrefUsecaseProvider = Provider((ref){
  return SaveFoodPrefUsecase(foodPrefRepository: ref.read(foodPrefRepositoryProvider));
});


class SaveFoodPrefUsecaseParam extends Equatable {
  final FoodPrefEntity foodPref;
  const SaveFoodPrefUsecaseParam({required this.foodPref});

  @override
  List<Object?> get props => [foodPref];
}

class SaveFoodPrefUsecase
    implements UsecaseWithParms<FoodPrefEntity, SaveFoodPrefUsecaseParam> {
  final IFoodPrefRepository _foodPrefRepository;
  SaveFoodPrefUsecase({required IFoodPrefRepository foodPrefRepository})
    : _foodPrefRepository = foodPrefRepository;
  @override
  Future<Either<Failure, FoodPrefEntity>> call(
    SaveFoodPrefUsecaseParam params,
  ) {
    return _foodPrefRepository.addfoodPreferences(params.foodPref);
  }
}
