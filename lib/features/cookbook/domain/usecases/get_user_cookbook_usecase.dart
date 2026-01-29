import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/cookbook/data/repositories/cookbook_repository_impl.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/repositories/cookbook_repository.dart';

class GetUserCookbookParams extends Equatable {
  final String userId;

  const GetUserCookbookParams({required this.userId});

  @override
  List<Object> get props => [userId];
}

final getUserCookbookUsecaseProvider = Provider((ref) {
  final repository = ref.watch(cookbookRepositoryProvider);
  return GetUserCookbookUsecase(repository: repository);
});

class GetUserCookbookUsecase
    implements
        UsecaseWithParms<List<CookbookRecipeEntity>, GetUserCookbookParams> {
  final ICookbookRepository _repository;

  GetUserCookbookUsecase({required ICookbookRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<CookbookRecipeEntity>>> call(
    GetUserCookbookParams params,
  ) {
    return _repository.getUserCookbook(params.userId);
  }
}
