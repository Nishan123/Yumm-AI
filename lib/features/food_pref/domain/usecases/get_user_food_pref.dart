import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/food_pref/data/repositories/food_pref_repository.dart';
import 'package:yumm_ai/features/food_pref/domain/entity/food_pref_entity.dart';
import 'package:yumm_ai/features/food_pref/domain/repositories/food_pref_repository.dart';

final getUserFoodPrefUsecaseProvider = Provider((ref) {
  return GetUserFoodPref(
    foodPrefRepository: ref.read(foodPrefRepositoryProvider),
  );
});

class GetUserFoodPrefParam extends Equatable {
  final String uid;
  const GetUserFoodPrefParam({required this.uid});
  @override
  List<Object?> get props => [uid];
}

class GetUserFoodPref
    implements UsecaseWithParms<FoodPrefEntity, GetUserFoodPrefParam> {
  final IFoodPrefRepository _foodPrefRepository;
  GetUserFoodPref({required IFoodPrefRepository foodPrefRepository})
    : _foodPrefRepository = foodPrefRepository;
  @override
  Future<Either<Failure, FoodPrefEntity>> call(GetUserFoodPrefParam params) {
    return _foodPrefRepository.getUserFoodPreferences(params.uid);
  }
}
