import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/features/cooking/data/repositories/recipe_repository_impl.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

/// Holds the currently selected meal type filter for public recipes
final selectedMealTypeProvider = StateProvider<Meal>((ref) => Meal.anything);

/// Provider for fetching public recipes with pagination and meal type filtering
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
    // Watch the selected meal type — auto-rebuilds when it changes
    final selectedMeal = ref.watch(selectedMealTypeProvider);

    _page = 1;
    _totalPages = 1;
    _isLoadingMore = false;

    final mealType = selectedMeal == Meal.anything ? null : selectedMeal.value;
    return _fetchRecipes(page: 1, mealType: mealType);
  }

  Future<List<RecipeEntity>> _fetchRecipes({
    required int page,
    String? mealType,
  }) async {
    final repository = ref.read(recipeRepositoryProvider);
    final result = await repository.getPublicRecipes(
      page: page,
      mealType: mealType,
    );

    return result.fold((failure) => throw failure, (data) {
      _totalPages = data.totalPages;
      return data.recipes;
    });
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || _page >= _totalPages) return;

    _isLoadingMore = true;
    try {
      final selectedMeal = ref.read(selectedMealTypeProvider);
      final mealType = selectedMeal == Meal.anything
          ? null
          : selectedMeal.value;

      final nextPage = _page + 1;
      final newRecipes = await _fetchRecipes(
        page: nextPage,
        mealType: mealType,
      );

      if (newRecipes.isNotEmpty) {
        _page = nextPage;
        final currentRecipes = state.value ?? [];
        state = AsyncData([...currentRecipes, ...newRecipes]);
      }
    } catch (e) {
      debugPrint("Error loading more recipes: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get canLoadMore => _page < _totalPages && !_isLoadingMore;
}
