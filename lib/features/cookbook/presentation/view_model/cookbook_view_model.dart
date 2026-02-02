import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/domain/entities/ingredient_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/initial_preparation_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/instruction_entity.dart';
import 'package:yumm_ai/features/chef/domain/usecases/delete_recipe_usecase.dart';
import 'package:yumm_ai/features/chef/domain/usecases/update_recipe_usecase.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/add_to_cookbook_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/check_recipe_with_fallback_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/full_update_cookbook_recipe_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/get_user_cookbook_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/get_user_recipe_by_original_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/is_recipe_in_cookbook_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/remove_from_cookbook_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/update_cookbook_recipe_usecase.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';

final cookbookViewModelProvider =
    NotifierProvider<CookbookViewModel, CookbookState>(
      () => CookbookViewModel(),
    );

class CookbookViewModel extends Notifier<CookbookState> {
  late final AddToCookbookUsecase _addToCookbookUsecase;
  late final GetUserCookbookUsecase _getUserCookbookUsecase;
  late final GetUserRecipeByOriginalUsecase _getUserRecipeByOriginalUsecase;
  late final UpdateCookbookRecipeUsecase _updateCookbookRecipeUsecase;
  late final IsRecipeInCookbookUsecase _isRecipeInCookbookUsecase;
  late final RemoveFromCookbookUsecase _removeFromCookbookUsecase;
  late final CheckRecipeWithFallbackUsecase _checkRecipeWithFallbackUsecase;
  late final DeleteRecipeUsecase _deleteRecipeUsecase;
  late final UpdateRecipeUsecase _updateRecipeUsecase;
  late final FullUpdateCookbookRecipeUsecase _fullUpdateCookbookRecipeUsecase;

  @override
  CookbookState build() {
    _addToCookbookUsecase = ref.read(addToCookbookUsecaseProvider);
    _getUserCookbookUsecase = ref.read(getUserCookbookUsecaseProvider);
    _getUserRecipeByOriginalUsecase = ref.read(
      getUserRecipeByOriginalUsecaseProvider,
    );
    _updateCookbookRecipeUsecase = ref.read(
      updateCookbookRecipeUsecaseProvider,
    );
    _isRecipeInCookbookUsecase = ref.read(isRecipeInCookbookUsecaseProvider);
    _removeFromCookbookUsecase = ref.read(removeFromCookbookUsecaseProvider);
    _checkRecipeWithFallbackUsecase = ref.read(
      checkRecipeWithFallbackUsecaseProvider,
    );
    _deleteRecipeUsecase = ref.read(deleteRecipeUsecaseProvider);
    _updateRecipeUsecase = ref.read(updateRecipeUsecaseProvider);
    _fullUpdateCookbookRecipeUsecase = ref.read(
      fullUpdateCookbookRecipeUsecaseProvider,
    );
    return const CookbookState();
  }

  /// Add a recipe to user's cookbook
  Future<void> addToCookbook({
    required String userId,
    required String recipeId,
  }) async {
    state = state.copyWith(status: CookbookStatus.adding);

    final result = await _addToCookbookUsecase.call(
      AddToCookbookParams(userId: userId, recipeId: recipeId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (recipe) {
        final updatedRecipes = [...state.recipes, recipe];
        state = state.copyWith(
          status: CookbookStatus.added,
          recipes: updatedRecipes,
          currentRecipe: recipe,
          isInCookbook: true,
        );
      },
    );
  }

  /// Get all recipes in user's cookbook
  Future<void> getUserCookbook(String userId) async {
    state = state.copyWith(status: CookbookStatus.loading);

    final result = await _getUserCookbookUsecase.call(
      GetUserCookbookParams(userId: userId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (recipes) {
        state = state.copyWith(status: CookbookStatus.loaded, recipes: recipes);
      },
    );
  }

  /// Get user's copy of a recipe by the original recipe ID
  Future<void> getUserRecipeByOriginal({
    required String userId,
    required String originalRecipeId,
  }) async {
    state = state.copyWith(status: CookbookStatus.loading);

    final result = await _getUserRecipeByOriginalUsecase.call(
      GetUserRecipeByOriginalParams(
        userId: userId,
        originalRecipeId: originalRecipeId,
      ),
    );

    result.fold(
      (failure) {
        // Don't set isInCookbook to false on fetch failure
        // The recipe might still be in cookbook, we just failed to fetch it
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (recipe) {
        state = state.copyWith(
          status: CookbookStatus.loaded,
          currentRecipe: recipe,
          isInCookbook: true,
        );
      },
    );
  }

  /// Check if a recipe is in user's cookbook
  Future<void> checkIsInCookbook({
    required String userId,
    required String originalRecipeId,
  }) async {
    final result = await _isRecipeInCookbookUsecase.call(
      IsRecipeInCookbookParams(
        userId: userId,
        originalRecipeId: originalRecipeId,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isInCookbook: false,
          errorMessage: failure.errorMessage,
        );
      },
      (isInCookbook) {
        state = state.copyWith(isInCookbook: isInCookbook);
      },
    );
  }

  /// Check if recipe is in cookbook and fetch user's copy with fallback handling
  ///
  /// This is the improved method that combines both checking and fetching into one
  /// operation with graceful error handling. It's recommended over calling
  /// checkIsInCookbook() followed by getUserRecipeByOriginal() separately.
  ///
  /// Returns a result indicating:
  /// - Whether the recipe is in the cookbook
  /// - The user's recipe copy (if available)
  /// - Whether to fallback to showing the original recipe
  Future<void> checkRecipeWithFallback({
    required String userId,
    required String originalRecipeId,
  }) async {
    state = state.copyWith(status: CookbookStatus.checking);

    final result = await _checkRecipeWithFallbackUsecase.call(
      CheckRecipeWithFallbackParams(
        userId: userId,
        originalRecipeId: originalRecipeId,
      ),
    );

    result.fold(
      (failure) {
        // Complete failure - couldn't even check if recipe is in cookbook
        state = state.copyWith(
          status: CookbookStatus.error,
          isInCookbook: false,
          errorMessage: failure.errorMessage,
        );
      },
      (checkResult) {
        if (checkResult.shouldFallback) {
          // Recipe is in cookbook but we couldn't fetch it - maintain isInCookbook=true
          // UI can show original recipe with "Already in cookbook" disabled state
          state = state.copyWith(
            status: CookbookStatus.error,
            isInCookbook: true,
            currentRecipe: null,
            errorMessage:
                checkResult.errorMessage ?? 'Failed to fetch your recipe copy',
          );
        } else if (checkResult.isInCookbook && checkResult.userRecipe != null) {
          // Success - recipe is in cookbook and we fetched it
          state = state.copyWith(
            status: CookbookStatus.loaded,
            isInCookbook: true,
            currentRecipe: checkResult.userRecipe,
          );
        } else {
          // Recipe is not in cookbook
          state = state.copyWith(
            status: CookbookStatus.loaded,
            isInCookbook: false,
            currentRecipe: null,
          );
        }
      },
    );
  }

  /// Toggle an ingredient's isReady status
  void toggleIngredient(int index, bool value) {
    if (state.currentRecipe == null) return;

    final ingredients = List<IngredientEntity>.from(
      state.currentRecipe!.ingredients,
    );
    ingredients[index] = ingredients[index].copyWith(isReady: value);

    final updatedRecipe = state.currentRecipe!.copyWith(
      ingredients: ingredients,
    );
    state = state.copyWith(currentRecipe: updatedRecipe);

    // Persist the change
    _updateRecipe(updatedRecipe);
  }

  /// Toggle an instruction's isDone status
  void toggleInstruction(int index, bool value) {
    if (state.currentRecipe == null) return;

    final steps = List<InstructionEntity>.from(state.currentRecipe!.steps);
    steps[index] = steps[index].copyWith(isDone: value);

    final updatedRecipe = state.currentRecipe!.copyWith(steps: steps);
    state = state.copyWith(currentRecipe: updatedRecipe);

    // Persist the change
    _updateRecipe(updatedRecipe);
  }

  /// Toggle an initial preparation's isDone status
  void toggleInitialPreparation(int index, bool value) {
    if (state.currentRecipe == null) return;

    final initialPreparation = List<InitialPreparationEntity>.from(
      state.currentRecipe!.initialPreparation,
    );

    // Create updated entity (InitialPreparationEntity needs copyWith)
    final current = initialPreparation[index];
    initialPreparation[index] = InitialPreparationEntity(
      id: current.id,
      step: current.step,
      isDone: value,
    );

    final updatedRecipe = state.currentRecipe!.copyWith(
      initialPreparation: initialPreparation,
    );
    state = state.copyWith(currentRecipe: updatedRecipe);

    // Persist the change
    _updateRecipe(updatedRecipe);
  }

  /// Toggle a kitchen tool's isReady status
  void toggleKitchenTool(int index, bool value) {
    if (state.currentRecipe == null) return;

    final kitchenTools = List<KitchenToolEntity>.from(
      state.currentRecipe!.kitchenTools,
    );
    kitchenTools[index] = kitchenTools[index].copyWith(isReady: value);

    final updatedRecipe = state.currentRecipe!.copyWith(
      kitchenTools: kitchenTools,
    );
    state = state.copyWith(currentRecipe: updatedRecipe);

    // Persist the change
    _updateRecipe(updatedRecipe);
  }

  /// Update the cookbook recipe on the server
  Future<void> _updateRecipe(CookbookRecipeEntity recipe) async {
    state = state.copyWith(status: CookbookStatus.updating);

    final result = await _updateCookbookRecipeUsecase.call(recipe);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (updatedRecipe) {
        // Update the recipe in the list
        final updatedRecipes = state.recipes.map((r) {
          return r.userRecipeId == updatedRecipe.userRecipeId
              ? updatedRecipe
              : r;
        }).toList();

        state = state.copyWith(
          status: CookbookStatus.updated,
          recipes: updatedRecipes,
          currentRecipe: updatedRecipe,
        );
      },
    );
  }

  /// Remove a recipe from user's cookbook
  Future<void> removeFromCookbook(String userRecipeId) async {
    state = state.copyWith(status: CookbookStatus.removing);

    final result = await _removeFromCookbookUsecase.call(
      RemoveFromCookbookParams(userRecipeId: userRecipeId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (success) {
        final updatedRecipes = state.recipes
            .where((r) => r.userRecipeId != userRecipeId)
            .toList();
        state = state
            .copyWith(
              status: CookbookStatus.removed,
              recipes: updatedRecipes,
              isInCookbook: false,
            )
            .clearCurrentRecipe();
      },
    );
  }

  /// Set the current recipe directly (e.g., when navigating to a recipe)
  void setCurrentRecipe(CookbookRecipeEntity recipe) {
    state = state.copyWith(currentRecipe: recipe);
  }

  /// Clear the current recipe
  void clearCurrentRecipe() {
    state = state.clearCurrentRecipe();
  }

  /// Reset state
  void reset() {
    state = const CookbookState();
  }

  /// Delete the original recipe (owner only)
  /// This will also delete all user cookbook copies via cascade
  Future<bool> deleteOriginalRecipe(String recipeId) async {
    state = state.copyWith(status: CookbookStatus.deleting);

    final result = await _deleteRecipeUsecase.call(
      DeleteRecipeParams(recipeId: recipeId, cascade: true),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
        );
        return false;
      },
      (success) {
        state = state
            .copyWith(status: CookbookStatus.deleted, isInCookbook: false)
            .clearCurrentRecipe();
        return true;
      },
    );
  }

  /// Delete a user's cookbook recipe copy
  /// This is for when a user removes their copy from their cookbook
  Future<bool> deleteCookbookRecipe(String userRecipeId) async {
    state = state.copyWith(status: CookbookStatus.deleting);

    final result = await _removeFromCookbookUsecase.call(
      RemoveFromCookbookParams(userRecipeId: userRecipeId),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
        );
        return false;
      },
      (success) {
        final updatedRecipes = state.recipes
            .where((r) => r.userRecipeId != userRecipeId)
            .toList();
        state = state
            .copyWith(
              status: CookbookStatus.deleted,
              recipes: updatedRecipes,
              isInCookbook: false,
            )
            .clearCurrentRecipe();
        return true;
      },
    );
  }

  /// Update the original recipe (owner only)
  Future<bool> updateOriginalRecipe(RecipeModel recipe) async {
    state = state.copyWith(status: CookbookStatus.updating);

    final result = await _updateRecipeUsecase.call(recipe);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
        );
        return false;
      },
      (updatedRecipe) {
        state = state.copyWith(status: CookbookStatus.updated);
        return true;
      },
    );
  }

  /// Full update of a cookbook recipe (content, not just progress)
  Future<bool> fullUpdateCookbookRecipe(CookbookRecipeEntity recipe) async {
    state = state.copyWith(status: CookbookStatus.updating);

    final result = await _fullUpdateCookbookRecipeUsecase.call(recipe);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
        );
        return false;
      },
      (updatedRecipe) {
        // Update the recipe in the list
        final updatedRecipes = state.recipes.map((r) {
          return r.userRecipeId == updatedRecipe.userRecipeId
              ? updatedRecipe
              : r;
        }).toList();

        state = state.copyWith(
          status: CookbookStatus.updated,
          recipes: updatedRecipes,
          currentRecipe: updatedRecipe,
        );
        return true;
      },
    );
  }
}
