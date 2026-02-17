import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/save_recipe/data/repositories/save_recipe_repository_impl.dart';
import 'package:yumm_ai/features/save_recipe/domain/repositories/save_recipe_repository.dart';

import 'package:equatable/equatable.dart';

final toggleSaveRecipeUsecaseProvider = Provider<ToggleSaveRecipeUsecase>((
  ref,
) {
  return ToggleSaveRecipeUsecase(
    repository: ref.read(savedRecipeRepositoryProvider),
  );
});

class ToggleSaveRecipeParams extends Equatable {
  final String recipeId;

  const ToggleSaveRecipeParams({required this.recipeId});

  @override
  List<Object> get props => [recipeId];
}

class ToggleSaveRecipeUsecase
    implements UsecaseWithParms<RecipeEntity, ToggleSaveRecipeParams> {
  final ISavedRecipeRepository _repository;

  ToggleSaveRecipeUsecase({required ISavedRecipeRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, RecipeEntity>> call(
    ToggleSaveRecipeParams params,
  ) async {
    return await _repository.toggleSaveRecipe(params.recipeId);
  }
}
