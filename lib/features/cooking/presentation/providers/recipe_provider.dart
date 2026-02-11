import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/cooking/data/repositories/recipe_repository_impl.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

/// Provider for fetching only public recipes (for home recommendations)
/// Provider for fetching public recipes with pagination
final publicRecipesProvider =
    AsyncNotifierProvider<PublicRecipesNotifier, List<RecipeEntity>>(
      PublicRecipesNotifier.new,
    );

class PublicRecipesNotifier extends AsyncNotifier<List<RecipeEntity>> {
  int _page = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  @override
  Future<List<RecipeEntity>> build() async {
    _page = 1;
    _totalPages = 1;
    _isLoadingMore = false;
    return _fetchRecipes(page: 1);
  }

  Future<List<RecipeEntity>> _fetchRecipes({required int page}) async {
    final repository = ref.read(recipeRepositoryProvider);
    final result = await repository.getPublicRecipes(page: page);

    return result.fold((failure) => throw failure, (data) {
      _totalPages = data.totalPages;
      return data.recipes;
    });
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || _page >= _totalPages) return;

    _isLoadingMore = true;
    try {
      final nextPage = _page + 1;
      final newRecipes = await _fetchRecipes(page: nextPage);

      if (newRecipes.isNotEmpty) {
        _page = nextPage;
        final currentRecipes = state.value ?? [];
        state = AsyncData([...currentRecipes, ...newRecipes]);
      }
    } catch (e) {
      // If an error occurs during pagination, we keep the current data
      // and potentially log the error. We don't want to replace the list with an error.
      // state = AsyncValue.error(e, st); // This would wipe the list.
      debugPrint("Error loading more recipes: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get canLoadMore => _page < _totalPages && !_isLoadingMore;
}
