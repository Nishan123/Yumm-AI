import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/data/repositories/ingredient_repository.dart';
import 'package:yumm_ai/features/chef/domain/repositories/ingredient_repository.dart';

final getIngredientsUsecaseProvider = Provider((ref) {
  final ingredientRepository = ref.watch(ingredientRepositoryProvider);
  return GetIngredientsUsecase(ingredientRepository: ingredientRepository);
});

class GetIngredientsUsecase
    implements UsecaseWithoutParms<List<IngredientModel>> {
  final IngredientRepository _ingredientRepository;

  GetIngredientsUsecase({required IngredientRepository ingredientRepository})
    : _ingredientRepository = ingredientRepository;

  @override
  Future<Either<Failure, List<IngredientModel>>> call() async {
    try {
      final ingredients = await _ingredientRepository.getIngredients();
      return Right(ingredients);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
