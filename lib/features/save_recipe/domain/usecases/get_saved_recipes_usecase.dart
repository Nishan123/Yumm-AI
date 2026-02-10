import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecase/usecase.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/save_recipe/data/repositories/save_recipe_repository_impl.dart';
import 'package:yumm_ai/features/save_recipe/domain/repositories/save_recipe_repository.dart';

final getSavedRecipesUsecaseProvider = Provider<GetSavedRecipesUsecase>((ref) {
  return GetSavedRecipesUsecase(
    repository: ref.read(savedRecipeRepositoryProvider),
  );
});

class GetSavedRecipesUsecase implements UseCase<List<RecipeEntity>, String> {
  final ISavedRecipeRepository _repository;

  GetSavedRecipesUsecase({required ISavedRecipeRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<RecipeEntity>>> call(String uid) async {
    return await _repository.getSavedRecipe(uid);
  }
}
