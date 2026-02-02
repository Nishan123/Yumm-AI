import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/constants/propmpts.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

class GenerateMacroChefPlanParams extends Equatable {
  final List<IngredientModel> ingridents;
  final double carbs;
  final double protein;
  final double fats;
  final double fiber;
  final double calories;
  final Meal mealType;
  final CookingExpertise cookingExpertise;
  final List<String> dietaryRistrictions;
  final Duration availableTime;

  const GenerateMacroChefPlanParams({
    required this.ingridents,
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.fiber,
    required this.calories,
    required this.mealType,
    required this.cookingExpertise,
    required this.dietaryRistrictions,
    required this.availableTime,
  });

  @override
  List<Object?> get props => [
    ingridents,
    carbs,
    protein,
    fats,
    fiber,
    calories,
    mealType,
    cookingExpertise,
    dietaryRistrictions,
    availableTime,
  ];
}

final generateMacroChefPlanUsecaseProvider = Provider<GenerateMacroChefPlanUsecase>((ref) {
  return GenerateMacroChefPlanUsecase();
});

class GenerateMacroChefPlanUsecase
    implements UsecaseWithParms<RecipeModel, GenerateMacroChefPlanParams> {
  @override
  Future<Either<Failure, RecipeModel>> call(
    GenerateMacroChefPlanParams params,
  ) async {
    try {
      final prompt = await Propmpts().getMacroChefPrompt(
        carbs: params.carbs,
        proteins: params.protein,
        fats: params.fats,
        fiber: params.fiber,
        availableIngridents: params.ingridents,
        mealType: params.mealType,
        dietaryRestrictions: params.dietaryRistrictions,
        availableTime: params.availableTime,
        cookingExperties: params.cookingExpertise,
        calories: params.calories,
      );

      final response = await Gemini.instance.prompt(parts: [Part.text(prompt)]);
      if (response?.output == null) {
        return Left(GeneralFailure("Failed to generate recipe"));
      }
      String jsonString = response!.output!;
      if (jsonString.contains('```json')) {
        jsonString = jsonString.replaceAll('```json', '').replaceAll('```', '');
      } else if (jsonString.contains('```')) {
        jsonString = jsonString.replaceAll('```', '');
      }

      final masterIngridents = await Propmpts.loadIngredients();
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final tempRecipe = RecipeModel.fromAiJson(
        jsonMap,
        params.ingridents,
        masterIngridents,
      );
      return Right(tempRecipe);
    } catch (e) {
      return Left((GeneralFailure(e.toString())));
    }
  }
}
