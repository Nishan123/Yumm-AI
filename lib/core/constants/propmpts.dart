import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';

class Propmpts {
  // Static cache for kitchen tools - loaded once, reused everywhere
  static List<KitchenToolModel>? _cachedKitchenTools;
  static String? _cachedKitchenToolsFormatted;
  // Static cache for ingredients
  static List<IngredientModel>? _cachedIngredients;

  // Load ingredients from JSON (cached after first load)
  static Future<List<IngredientModel>> loadIngredients() async {
    if (_cachedIngredients != null) return _cachedIngredients!;

    final String jsonString = await rootBundle.loadString(
      'assets/json/ingridents.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    _cachedIngredients = IngredientModel.fromJsonList(jsonList);
    return _cachedIngredients!;
  }

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
          KitchenToolModel(toolId: id, toolName: name, imageUrl: prefixImage),
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
              '- id="${t.toolId}" | toolName="${t.toolName}" | imageUrl="${t.imageUrl}"',
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
          return '- id="${i.ingredientId}" | ingredientName="${i.name}"$quantityInfo';
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
    List<String> dietaryRestrictions,
    List<String> allergicIngridetns,
  ) {
    return '''
{
  "recipeId": "<generate a unique UUID>",
  "recipeName": "<creative and descriptive recipe name>",
  "ingredients": [
    {
      "id": "<MUST use the exact id from the Available Ingredients list>",
      "ingredientName": "<MUST use the exact ingredientName from the Available Ingredients list>",
      "quantity": "<amount needed for this recipe>",
      "unit": "<measurement unit like 'cups', 'tbsp', 'pieces', etc.>",
      "isReady": falsek
    }
  ],
  "steps": [
    {
      "id": "<unique step id>",
      "instruction": "<Step 1: Be VERY detailed...dont add any kitchen tools ids or ingredient ids>",
      "isDone": false
    },
    {
       "id": "<unique step id>",
      "instruction": "<Step 2: Continue with same level of detail...dont add any kitchen tools ids or ingredient ids>",
      "isDone": false
    }
  ],
  "initialPreparation": [
    {
       "id": "<unique prep id>",
      "instruction": "<Prep 1: Be VERY detailed...dont add any kitchen tools ids or ingredient ids>",
      "isDone": false
    },
    {
       "id": "<unique prep id>",
      "instruction": "<Prep 2: Example...>",
      "isDone": false
    }
  ],
  "kitchenTools": [
    {
      "toolId": "<MUST use the exact id from tools json>",
      "toolName": "<MUSE use the exact toolName from tools json >",
      "imageUrl": "<MUST use the exact imageUrl from tools json>"
    }
  ],
  "experienceLevel": "$expertiseLevel",
  "estCookingTime": "<estimated time in format like '30min' or '1h 15min'>",
  "description": "<A compelling 2-3 sentence description of the dish, its flavors, and what makes it special>",
  "mealType": "$mealType",
  "cuisine": "<cuisine type like 'Italian', 'Asian', 'American', 'Mediterranean', etc.>",
  "calorie": <estimated calories per serving as a number>,
  "images": [],
  "nutrition": {
    "protein": <grams of protein as number>,
    "carbs": <grams of carbs as number>,
    "fat": <grams of fat as number>,
    "fiber": <grams of fiber as number>
  },
  "servings": $servings,
  "dietaryRestrictions": ${jsonEncode(dietaryRestrictions)}
}''';
  }

  /// Returns common recipe generation reminders
  String _getRecipeReminders() {
    return '''
Remember:
- Steps and Initial Preparation must be arrays of OBJECTS, not strings.
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
    List<String> dietaryRestrictions = const [],
    required List<String> allergicIngridents,
  }) async {
    final ingredientsList = _formatIngredients(availableIngridents);
    final kitchenToolsList = await _getFormattedKitchenTools();
    final kitchenTools = await _loadKitchenTools();
    final timeString = _formatDuration(availableTime);
    final expertiseLevel = cookingExperties.value;

    final allergicString = allergicIngridents.isEmpty
        ? 'None'
        : allergicIngridents.join(', ');

    return '''
You are an expert pantry chef and culinary instructor. Based on the available ingredients, create a delicious and practical recipe.


**Available Ingredients:**
$ingredientsList

**Available Kitchen Tools:**
$kitchenToolsList

**Meal Type:** ${mealType.name}
**Dietary Restrictions:** ${dietaryRestrictions.isEmpty ? 'None' : dietaryRestrictions.join(', ')}
**Allergic Ingredients:** $allergicString
**Available Cooking Time:** $timeString
**Cook's Experience Level:** $expertiseLevel

**Instructions:**
1. Create a recipe that ONLY uses the provided ingredients (you may assume basic pantry staples like salt, pepper, oil, and water are available).
2. The recipe MUST strictly adhere to ALL dietary restrictions listed above (if any).
3. CRITICAL: STRICTLY EXCLUDE any ingredients found in "**Allergic Ingredients**". Even if such an ingredient is listed in "**Available Ingredients**", you MUST IGNORE it completely. Do not include it in the recipe ingredients, instructions, or preparation.
4. The recipe must be completable within the available time.
5. Adjust complexity based on the cook's experience level.
6. Provide VERY DETAILED cooking steps - explain techniques, temperatures, visual/audio cues, and timing for each step.
7. Provide VERY DETAILED initial preparation steps - explain how to wash, cut, measure, and organize ingredients before cooking begins.
8. CRITICAL: In the "ingredients" array, the "id" and "ingredientName" fields MUST match EXACTLY with values from the "Available Ingredients" list above. Do not modify, abbreviate, or create new names. Only use the exact values provided.
9. CRITICAL: In the "kitchenTools" array, the "toolId", "toolName", and "imageUrl" fields MUST match EXACTLY with values from the "Available Kitchen Tools" list above. Do not include any tools not in this list. Only use tools from the provided list.

**IMPORTANT: Return ONLY a valid JSON object with NO additional text, markdown, or explanation. The response must be parseable JSON.**

Return the recipe in the following JSON structure:
${_getRecipeJsonStructure(expertiseLevel, mealType.name, 1, availableIngridents, kitchenTools, dietaryRestrictions, allergicIngridents)}

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
    required List<String> allergicIngridents,
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

    final allergicString = allergicIngridents.isEmpty
        ? 'None'
        : allergicIngridents.join(', ');

    return '''
You are a world-class master chef and culinary expert. Create an exceptional, restaurant-quality recipe tailored to the user's specific preferences and requirements.

**Available Ingredients:**
$ingredientsList

**Available Kitchen Tools:**
$kitchenToolsList

**Meal Type:** ${mealType.name}
**Meal Preferences:** ${mealPreferences.isEmpty ? 'No specific preferences' : mealPreferences}
**Dietary Restrictions:** $dietaryString
**Allergic Ingredients:** $allergicString
**Number of Servings:** $noOfServes
**Available Cooking Time:** $timeString
**Cook's Experience Level:** $expertiseLevel

**Instructions:**
1. Create a recipe that uses the provided ingredients as the primary components. You may add common pantry staples (salt, pepper, oil, butter, common spices, garlic, onion, etc.) to enhance the dish.
2. The recipe MUST strictly adhere to ALL dietary restrictions listed above. If a restriction is "Vegetarian", do not include any meat. If "Gluten-Free", avoid all gluten-containing ingredients, etc.
3. CRITICAL: STRICTLY EXCLUDE any ingredients found in "**Allergic Ingredients**". Even if such an ingredient is listed in "**Available Ingredients**", you MUST IGNORE it completely. Do not include it in the recipe ingredients, instructions, or preparation.
4. The recipe must be completable within the available time and scaled for the specified number of servings.
5. Consider the meal preferences when designing the dish - match the cuisine style, flavor profile, or specific requests mentioned.
6. Adjust complexity based on the cook's experience level:
   - For "newBie": Simple techniques, clear explanations, forgiving recipes
   - For "canCook": Intermediate techniques, some multi-tasking required
   - For "expert": Advanced techniques, complex flavor layering, precise timing
7. Provide VERY DETAILED cooking steps - explain techniques, temperatures, visual/audio cues, and timing for each step.
8. Provide VERY DETAILED initial preparation steps - explain how to wash, cut, measure, and organize ingredients before cooking begins.
9. CRITICAL: In the "ingredients" array, the "id" and "ingredientName" fields MUST match EXACTLY with values from the "Available Ingredients" list above. Do not modify, abbreviate, or create new names. Only use the exact values provided.
10. CRITICAL: In the "kitchenTools" array, the "toolId", "toolName", and "imageUrl" fields MUST match EXACTLY with values from the "Available Kitchen Tools" list above. Do not include any tools not in this list. Only use tools from the provided list.

**IMPORTANT: Return ONLY a valid JSON object with NO additional text, markdown, or explanation. The response must be parseable JSON.**

Return the recipe in the following JSON structure:
${_getRecipeJsonStructure(expertiseLevel, mealType.name, noOfServes, availableIngridents, kitchenTools, dietaryRestrictions, allergicIngridents)}

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
    required double calories,
    required List<String> allergicIngridents,
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

    final allergicString = allergicIngridents.isEmpty
        ? 'None'
        : allergicIngridents.join(', ');

    // Calculate estimated calories from macros (4 cal/g for carbs & protein, 9 cal/g for fat)
    final estimatedCalories = (carbs * 4) + (proteins * 4) + (fats * 9);

    return '''
You are a nutrition-focused chef and sports dietitian. Create a recipe that precisely meets the user's macronutrient targets while being delicious and practical to prepare.

**TARGET MACRONUTRIENTS (per serving):**
- Carbohydrates: ${carbs}g
- Protein: ${proteins}g
- Fats: ${fats}g
- Fiber: ${fiber}g
- Calories: ${calories}kcal
- Estimated Calories: ${estimatedCalories.toStringAsFixed(0)} kcal
try ignoring unrealstic macronutrients target value if possible but try your best to comeup if matching nutrients if possible.

**Available Ingredients:**
$ingredientsList

**Available Kitchen Tools:**
$kitchenToolsList

**Meal Type:** ${mealType.name}
**Dietary Restrictions:** $dietaryString
**Allergic Ingredients:** $allergicString
**Available Cooking Time:** $timeString
**Cook's Experience Level:** $expertiseLevel

**Instructions:**
1. Create a recipe that CLOSELY matches the target macronutrients above. The nutrition values in your response should be within ±10% of the targets.
2. Use the provided ingredients as the base, and you may suggest additional ingredients to meet the macro targets.
3. The recipe MUST strictly adhere to ALL dietary restrictions listed above.
4. CRITICAL: STRICTLY EXCLUDE any ingredients found in "**Allergic Ingredients**". Even if such an ingredient is listed in "**Available Ingredients**", you MUST IGNORE it completely. Do not include it in the recipe ingredients, instructions, or preparation.
5. The recipe must be completable within the available time.
6. Prioritize nutrient-dense, whole food ingredients that support the macro goals.
7. Calculate and provide ACCURATE nutrition information based on standard nutritional databases.
8. Adjust complexity based on the cook's experience level:
   - For "newBie": Simple techniques, clear explanations, forgiving recipes
   - For "canCook": Intermediate techniques, some multi-tasking required
   - For "expert": Advanced techniques, complex flavor layering, precise timing
9. Provide VERY DETAILED cooking steps - explain techniques, temperatures, visual/audio cues, and timing for each step.
10. Provide VERY DETAILED initial preparation steps - explain how to wash, cut, measure, and organize ingredients before cooking begins.
11. CRITICAL: In the "ingredients" array, the "id" and "ingredientName" fields MUST match EXACTLY with values from the "Available Ingredients" list above. Do not modify, abbreviate, or create new names. Only use the exact values provided.
12. CRITICAL: In the "kitchenTools" array, the "toolId", "toolName", and "imageUrl" fields MUST match EXACTLY with values from the "Available Kitchen Tools" list above. Do not include any tools not in this list. Only use tools from the provided list.

**CRITICAL: The nutrition object in the JSON response MUST closely match these targets:**
- protein: ~${proteins}g
- carbs: ~${carbs}g
- fat: ~${fats}g
- fiber: ~${fiber}g

**IMPORTANT: Return ONLY a valid JSON object with NO additional text, markdown, or explanation. The response must be parseable JSON.**

Return the recipe in the following JSON structure:
${_getRecipeJsonStructure(expertiseLevel, mealType.name, 1, availableIngridents, kitchenTools, dietaryRestrictions, allergicIngridents)}

${_getRecipeReminders()}
- CRITICAL: Match the target macros as closely as possible (within ±10%)
- The "nutrition" object values must reflect actual calculated nutritional content
- Include ingredient quantities that achieve the macro targets
- STRICTLY follow all dietary restrictions - this is critical for health and safety
- Suggest protein sources, complex carbs, and healthy fats that align with the targets
''';
  }
}
