import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/cookbook/data/repositories/cookbook_repository_impl.dart';
import 'package:yumm_ai/features/cookbook/domain/repositories/cookbook_repository.dart';

class RemoveFromCookbookParams extends Equatable {
  final String userRecipeId;

  const RemoveFromCookbookParams({required this.userRecipeId});

  @override
  List<Object> get props => [userRecipeId];
}

final removeFromCookbookUsecaseProvider = Provider((ref) {
  final repository = ref.watch(cookbookRepositoryProvider);
  return RemoveFromCookbookUsecase(repository: repository);
});

class RemoveFromCookbookUsecase
    implements UsecaseWithParms<bool, RemoveFromCookbookParams> {
  final ICookbookRepository _repository;

  RemoveFromCookbookUsecase({required ICookbookRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(RemoveFromCookbookParams params) {
    return _repository.removeFromCookbook(params.userRecipeId);
  }
}
