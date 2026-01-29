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
  return SaveRecipeUsecase(recipeRepository: recipeRepository);
});

class SaveRecipeUsecase
    implements UsecaseWithParms<RecipeEntity, SaveRecipeParams> {
  final RecipeRepository _recipeRepository;

  SaveRecipeUsecase({required RecipeRepository recipeRepository})
    : _recipeRepository = recipeRepository;

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

      // 3. Save Recipe
      final savedEntity = await _recipeRepository.saveRecipe(finalRecipe);
      return Right(savedEntity);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
