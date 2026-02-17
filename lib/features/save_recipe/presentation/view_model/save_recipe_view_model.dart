import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/save_recipe/domain/usecases/get_saved_recipes_usecase.dart';
import 'package:yumm_ai/features/save_recipe/domain/usecases/toggle_save_recipe_usecase.dart';
import 'package:yumm_ai/features/save_recipe/presentation/state/save_recipe_state.dart';

final saveRecipeViewModelProvider =
    NotifierProvider<SaveRecipeViewModel, SaveRecipeState>(
      () => SaveRecipeViewModel(),
    );

class SaveRecipeViewModel extends Notifier<SaveRecipeState> {
  late ToggleSaveRecipeUsecase _toggleSaveRecipeUsecase;
  late GetSavedRecipesUsecase _getSavedRecipesUsecase;

  @override
  SaveRecipeState build() {
    _toggleSaveRecipeUsecase = ref.read(toggleSaveRecipeUsecaseProvider);
    _getSavedRecipesUsecase = ref.read(getSavedRecipesUsecaseProvider);
    // Fetch saved recipes initially so we have the truth
    Future.microtask(() => getSavedRecipes());
    return SaveRecipeState.initial();
  }

  Future<void> getSavedRecipes() async {
    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.value;
    debugPrint("ViewModel: Getting saved recipes for user: ${user?.uid}");

    if (user == null || user.uid == null) {
      debugPrint("ViewModel: User is null, cannot get saved recipes");
      state = state.copyWith(isLoading: false);
      return;
    }

    // Only set loading if we don't have data yet to avoid flickering
    if (state.savedRecipes == null) {
      state = state.copyWith(isLoading: true);
    }

    final result = await _getSavedRecipesUsecase.call(
      GetSavedRecipesParams(uid: user.uid!),
    );
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (recipes) {
        state = state.copyWith(isLoading: false, savedRecipes: recipes);
      },
    );
  }

  Future<void> toggleSaveRecipe({
    required String recipeId,
    required VoidCallback onSuccess,
  }) async {
    state = state.copyWith(isToggleLoading: true);
    debugPrint("ViewModel: Toggling save for recipe $recipeId");

    final result = await _toggleSaveRecipeUsecase.call(
      ToggleSaveRecipeParams(recipeId: recipeId),
    );
    result.fold(
      (failure) {
        debugPrint("ViewModel: Toggle failed - ${failure.errorMessage}");
        state = state.copyWith(isToggleLoading: false, failure: failure);
      },
      (recipe) {
        debugPrint("ViewModel: Toggle success for recipe $recipeId");
        state = state.copyWith(isToggleLoading: false);
        // Always refresh the list to keep UI in sync
        getSavedRecipes();

        onSuccess();
      },
    );
  }

  bool isRecipeSaved(RecipeEntity recipe) {
    final user = ref.read(authViewModelProvider).user;
    if (user == null) {
      return false;
    }
    return recipe.likes.contains(user.uid);
  }
}
