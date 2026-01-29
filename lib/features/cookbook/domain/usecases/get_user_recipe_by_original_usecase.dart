import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/cookbook/data/repositories/cookbook_repository_impl.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/repositories/cookbook_repository.dart';

class GetUserRecipeByOriginalParams extends Equatable {
  final String userId;
  final String originalRecipeId;

  const GetUserRecipeByOriginalParams({
    required this.userId,
    required this.originalRecipeId,
  });

  @override
  List<Object> get props => [userId, originalRecipeId];
}

final getUserRecipeByOriginalUsecaseProvider = Provider((ref) {
  final repository = ref.watch(cookbookRepositoryProvider);
  return GetUserRecipeByOriginalUsecase(repository: repository);
});

class GetUserRecipeByOriginalUsecase
    implements
        UsecaseWithParms<CookbookRecipeEntity, GetUserRecipeByOriginalParams> {
  final ICookbookRepository _repository;

  GetUserRecipeByOriginalUsecase({required ICookbookRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CookbookRecipeEntity>> call(
    GetUserRecipeByOriginalParams params,
  ) {
    return _repository.getUserRecipeByOriginal(
      userId: params.userId,
      originalRecipeId: params.originalRecipeId,
    );
  }
}
