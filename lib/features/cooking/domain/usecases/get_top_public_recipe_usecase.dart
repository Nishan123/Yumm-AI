import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/domain/repositories/recipe_repository.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/cooking/data/repositories/recipe_repository_impl.dart';

final getTopPublicRecipeUsecaseProvider = Provider((ref) {
  final repository = ref.read(recipeRepositoryProvider);
  return GetTopPublicRecipeUsecase(repository: repository);
});

class GetTopPublicRecipeUsecase
    implements
        UsecaseWithParms<
          ({List<RecipeEntity> recipes, int total, int page, int totalPages}),
          ({int page, int limit})
        > {
  final IRecipeRepository repository;

  GetTopPublicRecipeUsecase({required this.repository});
  @override
  Future<
    Either<
      Failure,
      ({List<RecipeEntity> recipes, int total, int page, int totalPages})
    >
  >
  call(({int limit, int page}) params) async {
    return await repository.getTopPublicRecipes(
      page: params.page,
      limit: params.limit,
    );
  }
}
