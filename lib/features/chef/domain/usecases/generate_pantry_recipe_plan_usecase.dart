import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/constants/propmpts.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/gen_ai/gemini_service.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

class GeneratePantryRecipePlanParams extends Equatable {
  final List<IngredientModel> ingredients;
  final Meal mealType;
  final Duration availableTime;
  final CookingExpertise expertise;
  final String currentUserId;
  final List<String> allergicIngridents;

  const GeneratePantryRecipePlanParams({
    required this.ingredients,
    required this.mealType,
    required this.availableTime,
    required this.expertise,
    required this.currentUserId,
    required this.allergicIngridents,
  });

  @override
  List<Object?> get props => [
    ingredients,
    mealType,
    availableTime,
    expertise,
    currentUserId,
    allergicIngridents,
  ];
}

final generatePantryRecipePlanUsecaseProvider = Provider((ref) {
  return GeneratePantryRecipePlanUsecase(
    geminiService: ref.read(geminiServiceProvider),
  );
});

class GeneratePantryRecipePlanUsecase
    implements UsecaseWithParms<RecipeModel, GeneratePantryRecipePlanParams> {
  final GeminiService _geminiService;

  GeneratePantryRecipePlanUsecase({required GeminiService geminiService})
    : _geminiService = geminiService;
  @override
  Future<Either<Failure, RecipeModel>> call(
    GeneratePantryRecipePlanParams params,
  ) async {
    try {
      final prompt = await Propmpts().getPantryChefMealPrompt(
        availableIngridents: params.ingredients,
        mealType: params.mealType,
        availableTime: params.availableTime,
        cookingExperties: params.expertise,
        allergicIngridents: params.allergicIngridents,
      );

      final response = await _geminiService.promptAi(prompt);

      if (response?.output == null) {
        return Left(GeneralFailure("Failed to generate recipe text"));
      }

      String jsonString = response!.output!;
      jsonString = _geminiService.formatJsonResponse(jsonString);

      final masterIngredients = await Propmpts.loadIngredients();
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final tempRecipe = RecipeModel.fromAiJson(
        jsonMap,
        params.ingredients,
        masterIngredients,
      );

      return Right(tempRecipe);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
