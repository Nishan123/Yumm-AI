import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_recipe_images_usecase.dart';
import 'package:yumm_ai/features/chef/domain/usecases/save_recipe_usecase.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';

abstract class BaseChefViewModel extends Notifier<ChefState> {
  late final GenerateRecipeImagesUsecase generateRecipeImagesUsecase;
  late final SaveRecipeUsecase saveRecipeUsecase;

  void initBaseUsecases() {
    generateRecipeImagesUsecase = ref.read(generateRecipeImagesUsecaseProvider);
    saveRecipeUsecase = ref.read(saveRecipeUsecaseProvider);
  }

  Future<void> generateImagesAndSave({
    required RecipeModel tempRecipe,
    required String currentUserId,
    required bool isPublic,
  }) async {
    state = state.copyWith(
      status: ChefStatus.generatingImages,
      loadingMessage: "Generating images for the recipe.",
    );

    // final imageResult = await generateRecipeImagesUsecase.call(
    //   GenerateRecipeImagesParams(
    //     recipeName: tempRecipe.recipeName,
    //     description: tempRecipe.description,
    //   ),
    // );

    // await imageResult.fold(
    //   (failure) async =>
    //       await _saveRecipe(tempRecipe, [], currentUserId, isPublic),
    //   (images) async =>
    //       await _saveRecipe(tempRecipe, images, currentUserId, isPublic),
    // );

    await _saveRecipe(tempRecipe, [], currentUserId, isPublic);
  }

  Future<void> _saveRecipe(
    RecipeModel tempRecipe,
    List<Uint8List> images,
    String currentUserId,
    bool isPublic,
  ) async {
    state = state.copyWith(
      status: ChefStatus.savingRecipe,
      loadingMessage: "Saving your masterpiece...",
    );

    final saveResult = await saveRecipeUsecase.call(
      SaveRecipeParams(
        recipeModel: tempRecipe,
        generatedImages: images,
        currentUserId: currentUserId,
        isPublic: isPublic,
      ),
    );

    saveResult.fold(
      (failure) => state = state.copyWith(
        status: ChefStatus.error,
        errorMessage: failure.errorMessage,
        loadingMessage: null,
      ),
      (savedRecipe) => state = state.copyWith(
        status: ChefStatus.success,
        generatedRecipe: RecipeModel.fromEntity(savedRecipe),
        loadingMessage: null,
      ),
    );
  }
}
