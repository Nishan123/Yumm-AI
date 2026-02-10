import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

class SaveRecipeState {
  final bool isLoading;
  final List<RecipeEntity>? savedRecipes;
  final Failure? failure;
  final bool isToggleLoading;

  SaveRecipeState({
    this.isLoading = false,
    this.savedRecipes,
    this.failure,
    this.isToggleLoading = false,
  });

  factory SaveRecipeState.initial() {
    return SaveRecipeState(savedRecipes: null);
  }

  SaveRecipeState copyWith({
    bool? isLoading,
    List<RecipeEntity>? savedRecipes,
    Failure? failure,
    bool? isToggleLoading,
  }) {
    return SaveRecipeState(
      isLoading: isLoading ?? this.isLoading,
      savedRecipes: savedRecipes ?? this.savedRecipes,
      failure: failure ?? this.failure,
      isToggleLoading: isToggleLoading ?? this.isToggleLoading,
    );
  }
}
