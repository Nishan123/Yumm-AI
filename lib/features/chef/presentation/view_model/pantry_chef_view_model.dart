import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/features/chef/data/models/Ingrident_model.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_recipe_images_usecase.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_recipe_plan_usecase.dart';
import 'package:yumm_ai/features/chef/domain/usecases/save_recipe_usecase.dart';

// State
class PantryChefState {
  final bool isLoading;
  final String? loadingMessage;
  final RecipeModel? generatedRecipe;
  final String? error;

  PantryChefState({
    this.isLoading = false,
    this.loadingMessage,
    this.generatedRecipe,
    this.error,
  });

  PantryChefState copyWith({
    bool? isLoading,
    String? loadingMessage,
    RecipeModel? generatedRecipe,
    String? error,
  }) {
    return PantryChefState(
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      generatedRecipe: generatedRecipe ?? this.generatedRecipe,
      error: error,
    );
  }
}

final pantryChefViewModelProvider =
    NotifierProvider<PantryChefViewModel, PantryChefState>(
      PantryChefViewModel.new,
    );

class PantryChefViewModel extends Notifier<PantryChefState> {
  late final GenerateRecipePlanUsecase _generateRecipePlanUsecase;
  late final GenerateRecipeImagesUsecase _generateRecipeImagesUsecase;
  late final SaveRecipeUsecase _saveRecipeUsecase;

  @override
  PantryChefState build() {
    _generateRecipePlanUsecase = ref.read(generateRecipePlanUsecaseProvider);
    _generateRecipeImagesUsecase = ref.read(
      generateRecipeImagesUsecaseProvider,
    );
    _saveRecipeUsecase = ref.read(saveRecipeUsecaseProvider);
    return PantryChefState();
  }

  Future<void> generateMeal({
    required List<IngredientModel> ingredients,
    required Meal mealType,
    required Duration availableTime,
    required CookingExpertise expertise,
    required String currentUserId,
  }) async {
    state = state.copyWith(
      isLoading: true,
      loadingMessage: "Crafting your recipe with Gemini...",
      error: null,
    );

    // 1. Generate text recipe with Gemini
    final textResult = await _generateRecipePlanUsecase.call(
      GenerateRecipePlanParams(
        ingredients: ingredients,
        mealType: mealType,
        availableTime: availableTime,
        expertise: expertise,
        currentUserId: currentUserId,
      ),
    );

    // Handle failure or success for text generation
    await textResult.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
          loadingMessage: null,
        );
      },
      (tempRecipe) async {
        // 2. Generate Images
        state = state.copyWith(
          loadingMessage: "Generating mouth-watering images with Imagen 3.0...",
        );

        final imageResult = await _generateRecipeImagesUsecase.call(
          GenerateRecipeImagesParams(
            recipeName: tempRecipe.recipeName,
            description: tempRecipe.description,
          ),
        );

        await imageResult.fold(
          (failure) async {
            // If image generation fails, we might still want to save the recipe without images?
            // The original code allowed empty images on failure (though it logged and returned empty list).
            // Here, usecase returns Failure.
            // Let's assume we proceed with empty images if failure, OR show error.
            // Original code: "Fallback: Return empty list".
            // My Usecase implementation catches exception and returns Left(Failure).
            // I should handle Left by proceeding with empty list to match original resilience, OR stop.
            // Let's stop for now to be explicit about errors, OR proceed with warning.
            // Given "clean the chef feature without breaking any logic", original logic was resilient.
            // My usecase returns Left on error.
            // I will treat image failure as non-fatal but log it (or just pass empty list to save).

            // Actually, let's treat it as non-fatal.
            await _saveRecipe(tempRecipe, [], currentUserId);
          },
          (images) async {
            await _saveRecipe(tempRecipe, images, currentUserId);
          },
        );
      },
    );
  }

  Future<void> _saveRecipe(
    RecipeModel tempRecipe,
    List<Uint8List> images,
    String currentUserId,
  ) async {
    state = state.copyWith(loadingMessage: "Saving your masterpiece...");

    final saveResult = await _saveRecipeUsecase.call(
      SaveRecipeParams(
        recipeModel: tempRecipe,
        generatedImages: images,
        currentUserId: currentUserId,
      ),
    );

    saveResult.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
          loadingMessage: null,
        );
      },
      (savedRecipe) {
        // SavedRecipe is Entity, convert back to Model if needed for State
        // Or change State to hold Entity.
        // Current State holds RecipeModel.
        // RecipeModel.fromEntity(savedRecipe)
        state = state.copyWith(
          isLoading: false,
          generatedRecipe: RecipeModel.fromEntity(savedRecipe),
          loadingMessage: null,
        );
      },
    );
  }
}
