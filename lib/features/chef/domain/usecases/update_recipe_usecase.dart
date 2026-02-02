import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/data/repositories/recipe_repository_impl.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/chef/domain/repositories/recipe_repository.dart';

final updateRecipeUsecaseProvider = Provider((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return UpdateRecipeUsecase(repository: repository);
});

class UpdateRecipeUsecase
    implements UsecaseWithParms<RecipeEntity, RecipeModel> {
  final RecipeRepository _repository;

  UpdateRecipeUsecase({required RecipeRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, RecipeEntity>> call(RecipeModel recipe) async {
    try {
      final result = await _repository.updateRecipe(recipe);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
