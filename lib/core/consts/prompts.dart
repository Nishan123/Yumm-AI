import 'package:yumm_ai/models/ingredients_model.dart';
import 'package:yumm_ai/models/recipe_model.dart';

class Prompts {
  static final RecipeModel recipe = RecipeModel(
    recipeId: "",
    generatedBy: "",
    recipeTitle: "",
    ingredients: [],
    chefType: "",
    steps: [],
    tools: [],
    experienceLevel: "",
    availableCookingTime: Duration.zero,
    estimatedCookingDuration: "",
    cuisine: "",
    estimatedCalorie: "",
    mealType: "",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  static String getPantryChefPrompt(
    List<IngredientsModel> ingredients,
    String mealType,
    Duration availableTime,
    String cookingExperience,
  ) {
    final formattedTime = _formatDuration(availableTime);

    final ingredientList = ingredients
        .map(
          (item) => 'name: ${item.ingredientName}, id: ${item.id}, imageUrl ${item.prefixImage}',
        )
        .join('\n');

    return '''
You are PantryChef, an expert home cook who creates practical, realistic recipes using only the ingredients provided.

Context:
- Meal type: $mealType
- Available cooking time (hard limit): $formattedTime
- Cooking skill level: $cookingExperience
- Ingredients on hand:
$ingredientList

(You may assume basic pantry items such as salt, sugar, oil, and water are available, but do NOT list them as ingredients.)

Task:

- Generate one complete recipe that strictly fits the given time limit and skill level.
- Use only the provided ingredients, applying pantry-friendly substitutions only if absolutely necessary.
- Use basic home-kitchen equipment only.
- Output Requirements
- Output must be valid JSON only (no explanations, no extra text).
- Follow the structure shown in ${recipe.toJson()} exactly.
- Do not modify the schema.

Keep the following fields empty strings:

- recipeId
- generatedBy
- createdAt
- updatedAt

Ingredients Rules:
- Include only ingredients provided in the prompt.
- Do not include basic items such as salt, sugar, oil, or water.
- Ingredients must be an array of objects with this exact schema:

{
  "name": "Chicken breast",
  "quantity": "1 pound | 4 spoon | 2 liter | 1.2 milliliter",
  "id": "ing123",
  "prefixImage": "https://exmaple.com/images/egg.png"
}

Instructions Rules:

- instructions must be an array of strings only.
- Each string must contain one clear cooking step.
- Do not use objects inside the instructions array.

Time Constraint:

- estimatedDuration must not exceed availableCookingTime.
- Use this exact format:

"01hr 12min 00sec"
"00hr 30min 40sec"

Final Constraint: 

- Do not add extra fields.
- Do not invent ingredient IDs.
- Do not exceed time limits.
- Do not output anything outside the JSON.
''';
  }

  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${twoDigits(hours)}hr ${twoDigits(minutes)}min ${twoDigits(seconds)}sec';
  }
}
