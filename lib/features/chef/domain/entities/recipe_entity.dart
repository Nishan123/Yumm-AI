import 'initial_preparation_entity.dart';
import 'instruction_entity.dart';
import 'ingredient_entity.dart';
import '../../../kitchen_tool/domain/entities/kitchen_tool_entity.dart';
import 'nutrition_entity.dart';

class RecipeEntity {
  final String recipeId;
  final String generatedBy;
  final String recipeName;
  final List<IngredientEntity> ingredients;
  final List<InstructionEntity> steps;
  final List<InitialPreparationEntity> initialPreparation;
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
  final List<String> dietaryRestrictions;
  final bool isPublic;
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
    this.dietaryRestrictions = const [],
    this.isPublic = true,
    this.createdAt,
    this.updatedAt,
  });

  RecipeEntity copyWith({
    String? recipeId,
    String? generatedBy,
    String? recipeName,
    List<IngredientEntity>? ingredients,
    List<InstructionEntity>? steps,
    List<InitialPreparationEntity>? initialPreparation,
    List<KitchenToolEntity>? kitchenTools,
    String? experienceLevel,
    String? estCookingTime,
    String? description,
    String? mealType,
    String? cuisine,
    int? calorie,
    List<String>? images,
    NutritionEntity? nutrition,
    int? servings,
    List<String>? likes,
    List<String>? dietaryRestrictions,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecipeEntity(
      recipeId: recipeId ?? this.recipeId,
      generatedBy: generatedBy ?? this.generatedBy,
      recipeName: recipeName ?? this.recipeName,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      initialPreparation: initialPreparation ?? this.initialPreparation,
      kitchenTools: kitchenTools ?? this.kitchenTools,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      estCookingTime: estCookingTime ?? this.estCookingTime,
      description: description ?? this.description,
      mealType: mealType ?? this.mealType,
      cuisine: cuisine ?? this.cuisine,
      calorie: calorie ?? this.calorie,
      images: images ?? this.images,
      nutrition: nutrition ?? this.nutrition,
      servings: servings ?? this.servings,
      likes: likes ?? this.likes,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeEntity &&
          runtimeType == other.runtimeType &&
          recipeId == other.recipeId;

  @override
  int get hashCode => recipeId.hashCode;
}
