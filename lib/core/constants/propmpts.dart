import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/features/chef/data/models/Ingrident_model.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';

class Propmpts {
  // Static cache for kitchen tools - loaded once, reused everywhere
  static List<KitchenToolModel>? _cachedKitchenTools;
  static String? _cachedKitchenToolsFormatted;

  // Load kitchen tools from JSON (cached after first load)
  static Future<List<KitchenToolModel>> _loadKitchenTools() async {
    if (_cachedKitchenTools != null) return _cachedKitchenTools!;

    final String jsonString = await rootBundle.loadString(
      'assets/json/kitchen_tools.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    final List<KitchenToolModel> tools = [];
    for (var i = 0; i < jsonList.length; i++) {
      final item = jsonList[i];
      if (item is Map && item['name'] != null && item['prefixImage'] != null) {
        final id = (item['id'] ?? i).toString();
        final name = item['name'].toString();
        final prefixImage = item['prefixImage'].toString();
        tools.add(
          KitchenToolModel(id: id, name: name, prefixImage: prefixImage),
        );
      }
    }
    _cachedKitchenTools = tools;
    return tools;
  }

  // Get formatted kitchen tools string (cached)
  static Future<String> _getFormattedKitchenTools() async {
    if (_cachedKitchenToolsFormatted != null) {
      return _cachedKitchenToolsFormatted!;
    }

    final tools = await _loadKitchenTools();
    _cachedKitchenToolsFormatted = tools
        .map(
          (t) =>
              '- id="${t.id}" | toolName="${t.name}" | imageUrl="${t.prefixImage}"',
        )
        .join('\n');
    return _cachedKitchenToolsFormatted!;
  }

  // ============ HELPER METHODS ============

  String _formatIngredients(List<IngredientModel> ingredients) {
    return ingredients
        .map((i) {
          // Format: id=xxx | ingredientName=YYY | quantity/unit (if provided)
          final quantityInfo = (i.quantity.isNotEmpty || i.unit.isNotEmpty)
              ? ' | ${i.quantity} ${i.unit}'.trim()
              : '';
          return '- id="${i.id}" | ingredientName="${i.ingredientName}"$quantityInfo';
        })
        .join('\n');
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hour${hours > 1 ? 's' : ''}';
      }
      return '$hours hour${hours > 1 ? 's' : ''} and $remainingMinutes minutes';
    }
    return '$minutes minutes';
  }

  String _getRecipeJsonStructure(
    String expertiseLevel,
    String mealType,
    int servings,
    List<IngredientModel> selectedIngridents,
    List<KitchenToolModel> availableKitchenTools,
  ) {
    return '''
{
  "recipeId": "<generate a unique UUID>",
  "recipeName": "<creative and descriptive recipe name>",
  "ingridents": [
    {
      "id": "<MUST use the exact id from the Available Ingredients list>",
      "ingredientName": "<MUST use the exact ingredientName from the Available Ingredients list>",
      "quantity": "<amount needed for this recipe>",
      "unit": "<measurement unit like 'cups', 'tbsp', 'pieces', etc.>"
    }
  ],
  "steps": [
    "<Step 1: Be VERY detailed - include specific temperatures, timing, techniques, and sensory cues. Example: 'Heat a large non-stick skillet over medium-high heat (around 375°F/190°C) for 2 minutes until you see slight heat shimmer. Add 2 tablespoons of olive oil and swirl to coat the pan evenly. Wait 30 seconds until the oil begins to shimmer but not smoke.'>",
    "<Step 2: Continue with same level of detail for each cooking action>",
    "<Include ALL steps from start to plating>"
  ],
  "initialPrepration": [
    "<Prep 1: Be VERY detailed - Example: 'Rinse the chicken breast under cold running water and pat completely dry with paper towels. This ensures proper browning. Place on a clean cutting board.'>",
    "<Prep 2: Example: 'Dice the onion into 1/4-inch (6mm) uniform cubes: First cut off the root and stem ends, peel the outer layer, cut in half from root to stem, make horizontal cuts parallel to the cutting board, then vertical cuts, finally slice across to create even dice.'>",
    "<Prep 3: Example: 'Measure out all spices into a small bowl and mix together to create a spice blend. This mise en place ensures smooth cooking.'>",
    "<Include ALL preparation before cooking begins>"
  ],
  "kitchenTools": [
    {
      "toolId": "<MUST use the exact id from tools json>",
      "toolName": "<MUSE use the exact toolName from tools json >",
      "imageUrl": "<MUST use the exact imageUrl from tools json>"
    }
  ],
  "experienceLevel": "$expertiseLevel",
  "estCookingTime": "<estimated time in format like '30 mins' or '1 hour 15 mins'>",
  "description": "<A compelling 2-3 sentence description of the dish, its flavors, and what makes it special>",
  "mealType": "$mealType",
  "cusine": "<cuisine type like 'Italian', 'Asian', 'American', 'Mediterranean', etc.>",
  "calorie": <estimated calories per serving as a number>,
  "images": [],
  "nutrition": {
    "protein": <grams of protein as number>,
    "carbs": <grams of carbs as number>,
    "fat": <grams of fat as number>,
    "fiber": <grams of fiber as number>
  },
  "servings": $servings
}''';
  }

  /// Returns common recipe generation reminders
  String _getRecipeReminders() {
    return '''
Remember:
- Steps should be numbered implicitly by array order, not in the text
- Each step should be 2-4 sentences with specific details
- Initial preparation should cover ALL mise en place before any heat is applied
- Include at least 5-10 detailed cooking steps
- Include at least 3-5 detailed preparation steps
- Be specific about temperatures, times, and visual/audio cues
- Ensure the recipe is achievable with the given ingredients and time constraint''';
  }

  // ============ PROMPT METHODS ============

  Future<String> getPantryChefMealPrompt({
    required List<IngredientModel> availableIngridents,
    required Meal mealType,
    required Duration availableTime,
    required CookingExpertise cookingExperties,
  }) async {
    final ingredientsList = _formatIngredients(availableIngridents);
    final kitchenToolsList = await _getFormattedKitchenTools();
    final kitchenTools = await _loadKitchenTools();
    final timeString = _formatDuration(availableTime);
    final expertiseLevel = cookingExperties.value;

    return '''
You are an expert pantry chef and culinary instructor. Based on the available ingredients, create a delicious and practical recipe.

**Available Ingredients:**
$ingredientsList

**Available Kitchen Tools:**
$kitchenToolsList

**Meal Type:** ${mealType.name}
**Available Cooking Time:** $timeString
**Cook's Experience Level:** $expertiseLevel

**Instructions:**
1. Create a recipe that ONLY uses the provided ingredients (you may assume basic pantry staples like salt, pepper, oil, and water are available).
2. The recipe must be completable within the available time.
3. Adjust complexity based on the cook's experience level.
4. Provide VERY DETAILED cooking steps - explain techniques, temperatures, visual/audio cues, and timing for each step.
5. Provide VERY DETAILED initial preparation steps - explain how to wash, cut, measure, and organize ingredients before cooking begins.
6. CRITICAL: In the "ingridents" array, the "id" and "ingredientName" fields MUST match EXACTLY with values from the "Available Ingredients" list above. Do not modify, abbreviate, or create new names. Only use the exact values provided.
7. CRITICAL: In the "kitchenTools" array, the "toolId", "toolName", and "imageUrl" fields MUST match EXACTLY with values from the "Available Kitchen Tools" list above. Do not include any tools not in this list. Only use tools from the provided list.

**IMPORTANT: Return ONLY a valid JSON object with NO additional text, markdown, or explanation. The response must be parseable JSON.**

Return the recipe in the following JSON structure:
${_getRecipeJsonStructure(expertiseLevel, mealType.name, 1, availableIngridents, kitchenTools)}

${_getRecipeReminders()}
''';
  }

  Future<String> getMasterChefPrompt({
    required List<IngredientModel> availableIngridents,
    required Meal mealType,
    required List<String> dietaryRestrictions,
    required int noOfServes,
    required String mealPreferences,
    required Duration availableTime,
    required CookingExpertise cookingExperties,
  }) async {
    final ingredientsList = _formatIngredients(availableIngridents);
    final kitchenToolsList = await _getFormattedKitchenTools();
    final kitchenTools = await _loadKitchenTools();
    final timeString = _formatDuration(availableTime);
    final expertiseLevel = cookingExperties.value;

    // Format dietary restrictions
    final dietaryString = dietaryRestrictions.isEmpty
        ? 'None'
        : dietaryRestrictions.join(', ');

    return '''
You are a world-class master chef and culinary expert. Create an exceptional, restaurant-quality recipe tailored to the user's specific preferences and requirements.

**Available Ingredients:**
$ingredientsList

**Available Kitchen Tools:**
$kitchenToolsList

**Meal Type:** ${mealType.name}
**Meal Preferences:** ${mealPreferences.isEmpty ? 'No specific preferences' : mealPreferences}
**Dietary Restrictions:** $dietaryString
**Number of Servings:** $noOfServes
**Available Cooking Time:** $timeString
**Cook's Experience Level:** $expertiseLevel

**Instructions:**
1. Create a recipe that uses the provided ingredients as the primary components. You may add common pantry staples (salt, pepper, oil, butter, common spices, garlic, onion, etc.) to enhance the dish.
2. The recipe MUST strictly adhere to ALL dietary restrictions listed above. If a restriction is "Vegetarian", do not include any meat. If "Gluten-Free", avoid all gluten-containing ingredients, etc.
3. The recipe must be completable within the available time and scaled for the specified number of servings.
4. Consider the meal preferences when designing the dish - match the cuisine style, flavor profile, or specific requests mentioned.
5. Adjust complexity based on the cook's experience level:
   - For "newBie": Simple techniques, clear explanations, forgiving recipes
   - For "canCook": Intermediate techniques, some multi-tasking required
   - For "expert": Advanced techniques, complex flavor layering, precise timing
6. Provide VERY DETAILED cooking steps - explain techniques, temperatures, visual/audio cues, and timing for each step.
7. Provide VERY DETAILED initial preparation steps - explain how to wash, cut, measure, and organize ingredients before cooking begins.
8. CRITICAL: In the "ingridents" array, the "id" and "ingredientName" fields MUST match EXACTLY with values from the "Available Ingredients" list above. Do not modify, abbreviate, or create new names. Only use the exact values provided.
9. CRITICAL: In the "kitchenTools" array, the "toolId", "toolName", and "imageUrl" fields MUST match EXACTLY with values from the "Available Kitchen Tools" list above. Do not include any tools not in this list. Only use tools from the provided list.

**IMPORTANT: Return ONLY a valid JSON object with NO additional text, markdown, or explanation. The response must be parseable JSON.**

Return the recipe in the following JSON structure:
${_getRecipeJsonStructure(expertiseLevel, mealType.name, noOfServes, availableIngridents, kitchenTools)}

${_getRecipeReminders()}
- STRICTLY follow all dietary restrictions - this is critical for health and safety
- Scale ingredient quantities appropriately for $noOfServes serving(s)
- Consider the meal preferences: "$mealPreferences" when designing flavors and cuisine style
''';
  }

  Future<String> getMacroChefPrompt({
    required double carbs,
    required double proteins,
    required double fats,
    required double fiber,
    required List<IngredientModel> availableIngridents,
    required Meal mealType,
    required List<String> dietaryRestrictions,
    required Duration availableTime,
    required CookingExpertise cookingExperties,
  }) async {
    final ingredientsList = _formatIngredients(availableIngridents);
    final kitchenToolsList = await _getFormattedKitchenTools();
    final kitchenTools = await _loadKitchenTools();
    final timeString = _formatDuration(availableTime);
    final expertiseLevel = cookingExperties.value;

    // Format dietary restrictions
    final dietaryString = dietaryRestrictions.isEmpty
        ? 'None'
        : dietaryRestrictions.join(', ');

    // Calculate estimated calories from macros (4 cal/g for carbs & protein, 9 cal/g for fat)
    final estimatedCalories = (carbs * 4) + (proteins * 4) + (fats * 9);

    return '''
You are a nutrition-focused chef and sports dietitian. Create a recipe that precisely meets the user's macronutrient targets while being delicious and practical to prepare.

**TARGET MACRONUTRIENTS (per serving):**
- Carbohydrates: ${carbs}g
- Protein: ${proteins}g
- Fats: ${fats}g
- Fiber: ${fiber}g
- Estimated Calories: ${estimatedCalories.toStringAsFixed(0)} kcal

**Available Ingredients:**
$ingredientsList

**Available Kitchen Tools:**
$kitchenToolsList

**Meal Type:** ${mealType.name}
**Dietary Restrictions:** $dietaryString
**Available Cooking Time:** $timeString
**Cook's Experience Level:** $expertiseLevel

**Instructions:**
1. Create a recipe that CLOSELY matches the target macronutrients above. The nutrition values in your response should be within ±10% of the targets.
2. Use the provided ingredients as the base, and you may suggest additional ingredients to meet the macro targets.
3. The recipe MUST strictly adhere to ALL dietary restrictions listed above.
4. The recipe must be completable within the available time.
5. Prioritize nutrient-dense, whole food ingredients that support the macro goals.
6. Calculate and provide ACCURATE nutrition information based on standard nutritional databases.
7. Adjust complexity based on the cook's experience level:
   - For "newBie": Simple techniques, clear explanations, forgiving recipes
   - For "canCook": Intermediate techniques, some multi-tasking required
   - For "expert": Advanced techniques, complex flavor layering, precise timing
8. Provide VERY DETAILED cooking steps - explain techniques, temperatures, visual/audio cues, and timing for each step.
9. Provide VERY DETAILED initial preparation steps - explain how to wash, cut, measure, and organize ingredients before cooking begins.
10. CRITICAL: In the "ingridents" array, the "id" and "ingredientName" fields MUST match EXACTLY with values from the "Available Ingredients" list above. Do not modify, abbreviate, or create new names. Only use the exact values provided.
11. CRITICAL: In the "kitchenTools" array, the "toolId", "toolName", and "imageUrl" fields MUST match EXACTLY with values from the "Available Kitchen Tools" list above. Do not include any tools not in this list. Only use tools from the provided list.

**CRITICAL: The nutrition object in the JSON response MUST closely match these targets:**
- protein: ~${proteins}g
- carbs: ~${carbs}g
- fat: ~${fats}g
- fiber: ~${fiber}g

**IMPORTANT: Return ONLY a valid JSON object with NO additional text, markdown, or explanation. The response must be parseable JSON.**

Return the recipe in the following JSON structure:
${_getRecipeJsonStructure(expertiseLevel, mealType.name, 1, availableIngridents, kitchenTools)}

${_getRecipeReminders()}
- CRITICAL: Match the target macros as closely as possible (within ±10%)
- The "nutrition" object values must reflect actual calculated nutritional content
- Include ingredient quantities that achieve the macro targets
- STRICTLY follow all dietary restrictions - this is critical for health and safety
- Suggest protein sources, complex carbs, and healthy fats that align with the targets
''';
  }
}
