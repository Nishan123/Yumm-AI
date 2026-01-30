import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/chef/domain/repositories/recipe_repository.dart';
import 'package:yumm_ai/features/chef/data/repositories/recipe_repository_impl.dart';
import 'package:yumm_ai/features/cookbook/domain/repositories/cookbook_repository.dart';
import 'package:yumm_ai/features/cookbook/data/repositories/cookbook_repository_impl.dart';

class SaveRecipeParams extends Equatable {
  final RecipeModel recipeModel;
  final List<Uint8List> generatedImages;
  final String currentUserId;
  final bool isPublic;

  const SaveRecipeParams({
    required this.recipeModel,
    required this.generatedImages,
    required this.currentUserId,
    this.isPublic = true,
  });

  @override
  List<Object?> get props => [
    recipeModel,
    generatedImages,
    currentUserId,
    isPublic,
  ];
}

final saveRecipeUsecaseProvider = Provider((ref) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  final cookbookRepository = ref.watch(cookbookRepositoryProvider);
  return SaveRecipeUsecase(
    recipeRepository: recipeRepository,
    cookbookRepository: cookbookRepository,
  );
});

class SaveRecipeUsecase
    implements UsecaseWithParms<RecipeEntity, SaveRecipeParams> {
  final RecipeRepository _recipeRepository;
  final ICookbookRepository _cookbookRepository;

  SaveRecipeUsecase({
    required RecipeRepository recipeRepository,
    required ICookbookRepository cookbookRepository,
  }) : _recipeRepository = recipeRepository,
       _cookbookRepository = cookbookRepository;

  @override
  Future<Either<Failure, RecipeEntity>> call(SaveRecipeParams params) async {
    try {
      // 1. Upload Images
      List<String> imageUrls = [];
      if (params.generatedImages.isNotEmpty) {
        imageUrls = await _recipeRepository.uploadRecipeImages(
          recipeId: params.recipeModel.recipeId,
          images: params.generatedImages,
        );
      }

      // 2. Prepare Final Recipe Model
      final finalRecipe = params.recipeModel.copyWith(
        generatedBy: params.currentUserId,
        images: imageUrls,
        likes: [],
        isPublic: params.isPublic,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 3. Save Recipe based on visibility
      if (params.isPublic) {
        // Public recipe: Save to public Recipe collection
        final savedEntity = await _recipeRepository.saveRecipe(finalRecipe);
        return Right(savedEntity);
      } else {
        // Private recipe: Save directly to user's cookbook (UserRecipe collection)
        // This ensures private recipes are NEVER visible to other users
        final savedResult = await _cookbookRepository.savePrivateRecipe(
          recipe: finalRecipe,
          userId: params.currentUserId,
        );

        return savedResult.fold((failure) => Left(failure), (cookbookRecipe) {
          // Convert CookbookRecipeEntity to RecipeEntity for consistent return type
          return Right(
            RecipeEntity(
              recipeId: cookbookRecipe.originalRecipeId,
              generatedBy: cookbookRecipe.originalGeneratedBy,
              recipeName: cookbookRecipe.recipeName,
              ingredients: cookbookRecipe.ingredients,
              steps: cookbookRecipe.steps,
              initialPreparation: cookbookRecipe.initialPreparation,
              kitchenTools: cookbookRecipe.kitchenTools,
              experienceLevel: cookbookRecipe.experienceLevel,
              estCookingTime: cookbookRecipe.estCookingTime,
              description: cookbookRecipe.description,
              mealType: cookbookRecipe.mealType,
              cuisine: cookbookRecipe.cuisine,
              calorie: cookbookRecipe.calorie,
              images: cookbookRecipe.images,
              nutrition: cookbookRecipe.nutrition,
              servings: cookbookRecipe.servings,
              likes: [],
              isPublic: false,
              createdAt: cookbookRecipe.addedAt,
              updatedAt: cookbookRecipe.addedAt,
            ),
          );
        });
      }
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
