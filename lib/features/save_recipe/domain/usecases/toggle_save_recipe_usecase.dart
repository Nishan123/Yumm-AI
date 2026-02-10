import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecase/usecase.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/save_recipe/data/repositories/save_recipe_repository_impl.dart';
import 'package:yumm_ai/features/save_recipe/domain/repositories/save_recipe_repository.dart';

final toggleSaveRecipeUsecaseProvider = Provider<ToggleSaveRecipeUsecase>((
  ref,
) {
  return ToggleSaveRecipeUsecase(
    repository: ref.read(savedRecipeRepositoryProvider),
  );
});

class ToggleSaveRecipeUsecase implements UseCase<RecipeEntity, String> {
  final ISavedRecipeRepository _repository;

  ToggleSaveRecipeUsecase({required ISavedRecipeRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, RecipeEntity>> call(String params) async {
    return await _repository.toggleSaveRecipe(params);
  }
}
