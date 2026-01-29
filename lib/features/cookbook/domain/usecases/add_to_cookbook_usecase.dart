import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/cookbook/data/repositories/cookbook_repository_impl.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/repositories/cookbook_repository.dart';

class AddToCookbookParams extends Equatable {
  final String userId;
  final String recipeId;

  const AddToCookbookParams({required this.userId, required this.recipeId});

  @override
  List<Object> get props => [userId, recipeId];
}

final addToCookbookUsecaseProvider = Provider((ref) {
  final repository = ref.watch(cookbookRepositoryProvider);
  return AddToCookbookUsecase(repository: repository);
});

class AddToCookbookUsecase
    implements UsecaseWithParms<CookbookRecipeEntity, AddToCookbookParams> {
  final ICookbookRepository _repository;

  AddToCookbookUsecase({required ICookbookRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CookbookRecipeEntity>> call(
    AddToCookbookParams params,
  ) {
    return _repository.addToCookbook(
      userId: params.userId,
      recipeId: params.recipeId,
    );
  }
}
