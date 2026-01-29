import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/domain/entities/ingredient_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/initial_preparation_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/instruction_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/add_to_cookbook_usecase.dart';
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
        state = state.copyWith(
          status: CookbookStatus.error,
          errorMessage: failure.errorMessage,
          isInCookbook: false,
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
}
