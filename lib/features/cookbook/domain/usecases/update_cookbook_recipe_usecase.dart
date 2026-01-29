import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/cookbook/data/repositories/cookbook_repository_impl.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/repositories/cookbook_repository.dart';

final updateCookbookRecipeUsecaseProvider = Provider((ref) {
  final repository = ref.watch(cookbookRepositoryProvider);
  return UpdateCookbookRecipeUsecase(repository: repository);
});

class UpdateCookbookRecipeUsecase
    implements UsecaseWithParms<CookbookRecipeEntity, CookbookRecipeEntity> {
  final ICookbookRepository _repository;

  UpdateCookbookRecipeUsecase({required ICookbookRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CookbookRecipeEntity>> call(
    CookbookRecipeEntity recipe,
  ) {
    return _repository.updateUserRecipe(recipe);
  }
}
