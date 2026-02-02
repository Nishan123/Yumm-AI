import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/data/repositories/recipe_repository_impl.dart';
import 'package:yumm_ai/features/chef/domain/repositories/recipe_repository.dart';

class DeleteRecipeParams extends Equatable {
  final String recipeId;
  final bool cascade;

  const DeleteRecipeParams({required this.recipeId, this.cascade = true});

  @override
  List<Object?> get props => [recipeId, cascade];
}

final deleteRecipeUsecaseProvider = Provider((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return DeleteRecipeUsecase(repository: repository);
});

class DeleteRecipeUsecase
    implements UsecaseWithParms<bool, DeleteRecipeParams> {
  final RecipeRepository _repository;

  DeleteRecipeUsecase({required RecipeRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(DeleteRecipeParams params) async {
    try {
      final bool result;
      if (params.cascade) {
        result = await _repository.deleteRecipeWithCascade(params.recipeId);
      } else {
        result = await _repository.deleteRecipe(params.recipeId);
      }
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
