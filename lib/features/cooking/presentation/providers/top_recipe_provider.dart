import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/domain/usecases/get_top_public_recipe_usecase.dart';

final topPublicRecipesProvider =
    AsyncNotifierProvider<TopPublicRecipesNotifier, List<RecipeEntity>>(
      TopPublicRecipesNotifier.new,
    );

class TopPublicRecipesNotifier extends AsyncNotifier<List<RecipeEntity>> {
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
    final usecase = ref.read(getTopPublicRecipeUsecaseProvider);
    final result = await usecase((page: page, limit: 10));

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
      debugPrint("Error loading more top recipes: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get canLoadMore => _page < _totalPages && !_isLoadingMore;
}
