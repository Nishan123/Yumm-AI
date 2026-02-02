import 'package:yumm_ai/features/chef/domain/entities/ingredient_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/initial_preparation_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/instruction_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/nutrition_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';

/// Entity representing a user-specific recipe instance in their cookbook.
/// This allows users to track their own progress (checked ingredients, instructions, tools)
/// without affecting the original shared recipe or other users' progress.
class CookbookRecipeEntity {
  /// Unique identifier for this user-recipe instance
  final String userRecipeId;

  /// The user who owns this cookbook entry
  final String userId;

  /// Reference to the original recipe
  final String originalRecipeId;

  /// Who originally created the recipe
  final String originalGeneratedBy;

  /// Recipe name
  final String recipeName;

  /// User's ingredient list with their own progress tracking
  final List<IngredientEntity> ingredients;

  /// User's instruction steps with their own progress tracking
  final List<InstructionEntity> steps;

  /// User's initial preparation steps with their own progress tracking
  final List<InitialPreparationEntity> initialPreparation;

  /// User's kitchen tools list with their own progress tracking
  final List<KitchenToolEntity> kitchenTools;

  /// Experience level required
  final String experienceLevel;

  /// Estimated cooking time
  final String estCookingTime;

  /// Recipe description
  final String description;

  /// Meal type (breakfast, lunch, dinner, etc.)
  final String mealType;

  /// Cuisine type
  final String cuisine;

  /// Calorie count
  final int calorie;

  /// Recipe images
  final List<String> images;

  /// Nutrition information
  final NutritionEntity? nutrition;

  /// Number of servings
  final int servings;

  /// When the recipe was added to cookbook
  final DateTime? addedAt;

  /// When this instance was created
  final DateTime? createdAt;

  /// When this instance was last updated
  final DateTime? updatedAt;

  const CookbookRecipeEntity({
    required this.userRecipeId,
    required this.userId,
    required this.originalRecipeId,
    required this.originalGeneratedBy,
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
    this.addedAt,
    this.createdAt,
    this.updatedAt,
  });

  CookbookRecipeEntity copyWith({
    String? userRecipeId,
    String? userId,
    String? originalRecipeId,
    String? originalGeneratedBy,
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
    DateTime? addedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CookbookRecipeEntity(
      userRecipeId: userRecipeId ?? this.userRecipeId,
      userId: userId ?? this.userId,
      originalRecipeId: originalRecipeId ?? this.originalRecipeId,
      originalGeneratedBy: originalGeneratedBy ?? this.originalGeneratedBy,
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
      addedAt: addedAt ?? this.addedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CookbookRecipeEntity &&
          runtimeType == other.runtimeType &&
          userRecipeId == other.userRecipeId;

  @override
  int get hashCode => userRecipeId.hashCode;

  /// Convert to a RecipeEntity for use in screens that expect the original type.
  /// Uses originalRecipeId as the recipeId so that lookups work correctly.
  RecipeEntity toRecipeEntity() {
    return RecipeEntity(
      recipeId: originalRecipeId,
      generatedBy: originalGeneratedBy,
      recipeName: recipeName,
      ingredients: ingredients,
      steps: steps,
      initialPreparation: initialPreparation,
      kitchenTools: kitchenTools,
      experienceLevel: experienceLevel,
      estCookingTime: estCookingTime,
      description: description,
      mealType: mealType,
      cuisine: cuisine,
      calorie: calorie,
      images: images,
      nutrition: nutrition,
      servings: servings,
      likes: [],
      isPublic: false,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
