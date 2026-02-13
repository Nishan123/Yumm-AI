import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/search/domain/repositories/search_repository.dart';
import 'package:yumm_ai/features/search/data/repositories/search_repository_impl.dart';

final searchRecipesUseCaseProvider = Provider<SearchRecipesUseCase>((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return SearchRecipesUseCase(repository: repository);
});

class SearchRecipesUseCase {
  final SearchRepository _repository;

  SearchRecipesUseCase({required SearchRepository repository})
    : _repository = repository;

  Future<Either<Failure, ({List<RecipeEntity> recipes, int totalPages})>> call({
    required int page,
    required int size,
    required String searchTerm,
    String? experienceLevel,
    String? mealType,
    double? minCalorie,
    double? maxCalorie,
  }) {
    return _repository.searchRecipes(
      page: page,
      size: size,
      searchTerm: searchTerm,
      experienceLevel: experienceLevel,
      mealType: mealType,
      minCalorie: minCalorie,
      maxCalorie: maxCalorie,
    );
  }
}
