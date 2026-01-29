import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/cookbook/data/repositories/cookbook_repository_impl.dart';
import 'package:yumm_ai/features/cookbook/domain/repositories/cookbook_repository.dart';

class IsRecipeInCookbookParams extends Equatable {
  final String userId;
  final String originalRecipeId;

  const IsRecipeInCookbookParams({
    required this.userId,
    required this.originalRecipeId,
  });

  @override
  List<Object> get props => [userId, originalRecipeId];
}

final isRecipeInCookbookUsecaseProvider = Provider((ref) {
  final repository = ref.watch(cookbookRepositoryProvider);
  return IsRecipeInCookbookUsecase(repository: repository);
});

class IsRecipeInCookbookUsecase
    implements UsecaseWithParms<bool, IsRecipeInCookbookParams> {
  final ICookbookRepository _repository;

  IsRecipeInCookbookUsecase({required ICookbookRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(IsRecipeInCookbookParams params) {
    return _repository.isRecipeInCookbook(
      userId: params.userId,
      originalRecipeId: params.originalRecipeId,
    );
  }
}
