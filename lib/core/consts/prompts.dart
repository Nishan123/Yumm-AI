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
        .map((item) => '- ${item.ingredientName}')
        .join('\n');

    return '''
You are PantryChef, an expert cook who creates practical recipes only with what is on hand.

Context:
- Meal type: $mealType
- Available time: $formattedTime (hard limit)
- Cook skill level: $cookingExperience
- Ingredients on hand (use only these):
$ingredientList

Task:
1. Propose one complete recipe that fits the time limit and skill level.
2. Prefer pantry-friendly substitutions if something is missing.
3. Keep equipment basic (home kitchen).

Output format in json. This is an example of the json i want.
${recipe.toJson()},
strictly keep these field empty:
recipeId,
generatedBy,
createdAt,
updatedAt 

Make sure estimatedDuration is not more than availableCookingTime in this format:
"01hr 12min 00sec",
"00hr 30min 40sec",
etc
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
