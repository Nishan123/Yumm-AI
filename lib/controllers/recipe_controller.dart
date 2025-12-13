import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:yumm_ai/core/consts/prompts.dart';
import 'package:yumm_ai/models/ingredients_model.dart';

class RecipeController {
  void generateRecipe(
    List<IngredientsModel> ingredients,
    String mealType,
    Duration availableTime,
    String cookingExperience,
  ) async{
    Gemini.instance
        .prompt(
          parts: [
          Part.text( Prompts.getPantryChefPrompt(ingredients, mealType, availableTime, cookingExperience))
          ],
        )
        .then((value) {
          debugPrint(
            "Gemini Response: ${value?.output ?? "Failed to generate res"}",
          );
        });
  }
}
