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

class GenerateMasterRecipePlanParams extends Equatable {
  final List<IngredientModel> ingridents;
  final Meal mealType;
  final Duration availableTime;
  final CookingExpertise expertise;
  final int noOfServes;
  final List<String> dietaryRestrictions;
  final String mealPreferences;
  final List<String> allergicIngridents;

  const GenerateMasterRecipePlanParams({
    required this.ingridents,
    required this.mealType,
    required this.availableTime,
    required this.expertise,
    required this.noOfServes,
    required this.dietaryRestrictions,
    required this.mealPreferences,
    required this.allergicIngridents
  });

  @override
  List<Object?> get props => [
    ingridents,
    mealType,
    availableTime,
    expertise,
    noOfServes,
    dietaryRestrictions,
    mealPreferences,
    allergicIngridents
  ];
}

final generateMasterRecipePlanUsecaseProvider = Provider((ref) {
  return GenerateMasterRecipePlanUsecase();
});

class GenerateMasterRecipePlanUsecase
    implements UsecaseWithParms<RecipeModel, GenerateMasterRecipePlanParams> {
  @override
  Future<Either<Failure, RecipeModel>> call(
    GenerateMasterRecipePlanParams params,
  ) async {
    try {
      final prompt = await Propmpts().getMasterChefPrompt(
        availableIngridents: params.ingridents,
        mealType: params.mealType,
        dietaryRestrictions: params.dietaryRestrictions,
        noOfServes: params.noOfServes,
        mealPreferences: params.mealPreferences,
        availableTime: params.availableTime,
        cookingExperties: params.expertise,
        allergicIngridents: params.allergicIngridents,
      );
      final response = await Gemini.instance.prompt(parts: [Part.text(prompt)]);

      if (response?.output == null) {
        return Left(GeneralFailure("Failed to generate recipe text"));
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
