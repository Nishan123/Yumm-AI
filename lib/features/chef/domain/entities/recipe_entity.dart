import 'ingredient_entity.dart';
import '../../../kitchen_tool/domain/entities/kitchen_tool_entity.dart';
import 'nutrition_entity.dart';

class RecipeEntity {
  final String recipeId;
  final String generatedBy;
  final String recipeName;
  final List<IngredientEntity> ingredients;
  final List<String> steps;
  final List<String> initialPreparation;
  final List<KitchenToolEntity> kitchenTools;
  final String experienceLevel;
  final String estCookingTime;
  final String description;
  final String mealType;
  final String cuisine;
  final int calorie;
  final List<String> images;
  final NutritionEntity? nutrition;
  final int servings;
  final List<String> likes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RecipeEntity({
    required this.recipeId,
    required this.generatedBy,
    required this.recipeName,
    required this.ingredients,
    required this.steps,
    required this.initialPreparation,
    required this.kitchenTools,
    required this.experienceLevel,
    required this.estCookingTime,
    required this.description,
    required this.mealType,
    required this.cuisine,
    required this.calorie,
    required this.images,
    this.nutrition,
    required this.servings,
    required this.likes,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeEntity &&
          runtimeType == other.runtimeType &&
          recipeId == other.recipeId;

  @override
  int get hashCode => recipeId.hashCode;
}
