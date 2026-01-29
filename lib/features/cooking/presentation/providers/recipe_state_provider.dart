import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/domain/entities/ingredient_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/instruction_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/presentation/view_model/cooking_view_model.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';

/// State class that holds cached recipe states by recipeId.
/// This is an immutable state class for proper Riverpod reactivity.
/// Uses a version counter to ensure state changes are detected even when
/// the underlying RecipeEntity equality only compares by ID.
class RecipeStateCache {
  final Map<String, RecipeEntity> _cache;
  final int _version;

  const RecipeStateCache([Map<String, RecipeEntity>? cache, int version = 0])
    : _cache = cache ?? const {},
      _version = version;

  RecipeEntity? get(String recipeId) => _cache[recipeId];

  int get version => _version;

  RecipeStateCache copyWith(String recipeId, RecipeEntity recipe) {
    final newCache = Map<String, RecipeEntity>.from(_cache);
    newCache[recipeId] = recipe;
    // Increment version to ensure state change is detected
    return RecipeStateCache(newCache, _version + 1);
  }

  RecipeStateCache remove(String recipeId) {
    final newCache = Map<String, RecipeEntity>.from(_cache);
    newCache.remove(recipeId);
    return RecipeStateCache(newCache, _version + 1);
  }

  RecipeStateCache clear() {
    return RecipeStateCache(const {}, _version + 1);
  }

  bool contains(String recipeId) => _cache.containsKey(recipeId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeStateCache &&
          runtimeType == other.runtimeType &&
          _version == other._version &&
          mapEquals(_cache, other._cache);

  @override
  int get hashCode => Object.hash(_version, _cache);
}

/// Provider for the recipe state notifier.
final recipeStateCacheProvider =
    NotifierProvider<RecipeStateCacheNotifier, RecipeStateCache>(
      RecipeStateCacheNotifier.new,
    );

class RecipeStateCacheNotifier extends Notifier<RecipeStateCache> {
  @override
  RecipeStateCache build() {
    return const RecipeStateCache();
  }

  /// Initialize a recipe state if not already cached.
  void initializeIfNeeded(String recipeId, RecipeEntity recipe) {
    if (!state.contains(recipeId)) {
      state = state.copyWith(recipeId, recipe);
    }
  }

  /// Force initialize/update a recipe state.
  void initialize(String recipeId, RecipeEntity recipe) {
    state = state.copyWith(recipeId, recipe);
  }

  /// Get recipe by id
  RecipeEntity? getRecipe(String recipeId) {
    return state.get(recipeId);
  }

  /// Toggle an ingredient's isReady status
  void toggleIngredient(String recipeId, int index, bool value) {
    final recipe = state.get(recipeId);
    if (recipe == null) return;

    final ingredients = List<IngredientEntity>.from(recipe.ingredients);
    ingredients[index] = ingredients[index].copyWith(isReady: value);

    final newRecipe = recipe.copyWith(ingredients: ingredients);
    state = state.copyWith(recipeId, newRecipe);

    // Persist the change to backend
    ref.read(cookingViewModelProvider.notifier).updateRecipe(newRecipe);
  }

  /// Toggle an instruction's isDone status
  void toggleInstruction(String recipeId, int index, bool value) {
    final recipe = state.get(recipeId);
    if (recipe == null) return;

    final steps = List<InstructionEntity>.from(recipe.steps);
    steps[index] = steps[index].copyWith(isDone: value);

    final newRecipe = recipe.copyWith(steps: steps);
    state = state.copyWith(recipeId, newRecipe);

    // Persist the change to backend
    ref.read(cookingViewModelProvider.notifier).updateRecipe(newRecipe);
  }

  /// Toggle a kitchen tool's isReady status
  void toggleKitchenTool(String recipeId, int index, bool value) {
    final recipe = state.get(recipeId);
    if (recipe == null) return;

    final kitchenTools = List<KitchenToolEntity>.from(recipe.kitchenTools);
    kitchenTools[index] = kitchenTools[index].copyWith(isReady: value);

    final newRecipe = recipe.copyWith(kitchenTools: kitchenTools);
    state = state.copyWith(recipeId, newRecipe);

    // Persist the change to backend
    ref.read(cookingViewModelProvider.notifier).updateRecipe(newRecipe);
  }

  /// Reset all recipe states (e.g., when logging out)
  void reset() {
    state = state.clear();
  }

  /// Remove a specific recipe from cache
  void removeRecipe(String recipeId) {
    state = state.remove(recipeId);
  }
}

/// State wrapper that includes the recipe and a version for change detection.
/// This ensures Riverpod detects changes even when RecipeEntity equality is ID-based.
class RecipeStateSnapshot {
  final RecipeEntity? recipe;
  final int version;

  const RecipeStateSnapshot({this.recipe, this.version = 0});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeStateSnapshot &&
          runtimeType == other.runtimeType &&
          version == other.version;

  @override
  int get hashCode => version.hashCode;
}

/// Selector provider to get a specific recipe's state with proper change detection.
/// Returns a RecipeStateSnapshot that includes version tracking to ensure
/// UI updates are triggered when recipe content changes.
final recipeStateProvider = Provider.family<RecipeStateSnapshot, String>((
  ref,
  recipeId,
) {
  final cache = ref.watch(recipeStateCacheProvider);
  return RecipeStateSnapshot(
    recipe: cache.get(recipeId),
    version: cache.version,
  );
});
