import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/save_recipe/data/repositories/save_recipe_repository_impl.dart';
import 'package:yumm_ai/features/save_recipe/domain/repositories/save_recipe_repository.dart';

import 'package:equatable/equatable.dart';

final getSavedRecipesUsecaseProvider = Provider<GetSavedRecipesUsecase>((ref) {
  return GetSavedRecipesUsecase(
    repository: ref.read(savedRecipeRepositoryProvider),
  );
});

class GetSavedRecipesParams extends Equatable {
  final String uid;

  const GetSavedRecipesParams({required this.uid});

  @override
  List<Object> get props => [uid];
}

class GetSavedRecipesUsecase
    implements UsecaseWithParms<List<RecipeEntity>, GetSavedRecipesParams> {
  final ISavedRecipeRepository _repository;

  GetSavedRecipesUsecase({required ISavedRecipeRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<RecipeEntity>>> call(
    GetSavedRecipesParams params,
  ) async {
    return await _repository.getSavedRecipe(params.uid);
  }
}
