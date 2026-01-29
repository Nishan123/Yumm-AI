import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/data/models/initial_preparation_model.dart';
import 'package:yumm_ai/features/chef/data/models/instruction_model.dart';
import 'package:yumm_ai/features/chef/data/models/nutrition_model.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';

/// Model for user-specific recipe instances in their cookbook.
/// Handles JSON serialization and conversion to/from entity.
class CookbookRecipeModel {
  final String userRecipeId;
  final String userId;
  final String originalRecipeId;
  final String originalGeneratedBy;
  final String recipeName;
  final List<IngredientModel> ingredients;
  final List<InstructionModel> steps;
  final List<InitialPreparationModel> initialPreparation;
  final List<KitchenToolModel> kitchenTools;
  final String experienceLevel;
  final String estCookingTime;
  final String description;
  final String mealType;
  final String cuisine;
  final int calorie;
  final List<String> images;
  final NutritionModel? nutrition;
  final int servings;
  final DateTime? addedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CookbookRecipeModel({
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

  /// Convert model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'userRecipeId': userRecipeId,
      'userId': userId,
      'originalRecipeId': originalRecipeId,
      'originalGeneratedBy': originalGeneratedBy,
      'recipeName': recipeName,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps.map((e) => e.toJson()).toList(),
      'initialPreparation': initialPreparation.map((e) => e.toJson()).toList(),
      'kitchenTools': kitchenTools.map((e) => e.toJson()).toList(),
      'experienceLevel': experienceLevel,
      'estCookingTime': estCookingTime,
      'description': description,
      'mealType': mealType,
      'cuisine': cuisine,
      'calorie': calorie,
      'images': images,
      'nutrition': nutrition?.toJson(),
      'servings': servings,
      'addedAt': addedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create model from JSON map
  factory CookbookRecipeModel.fromJson(Map<String, dynamic> json) {
    return CookbookRecipeModel(
      userRecipeId: json['userRecipeId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      originalRecipeId: json['originalRecipeId'] as String? ?? '',
      originalGeneratedBy: json['originalGeneratedBy'] as String? ?? '',
      recipeName: json['recipeName'] as String? ?? '',
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List<dynamic>)
                .map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      steps: json['steps'] != null
          ? InstructionModel.fromJsonList(json['steps'] as List<dynamic>)
          : [],
      initialPreparation: json['initialPreparation'] != null
          ? InitialPreparationModel.fromJsonList(
              json['initialPreparation'] as List<dynamic>,
            )
          : [],
      kitchenTools: json['kitchenTools'] != null
          ? KitchenToolModel.fromJsonList(json['kitchenTools'] as List<dynamic>)
          : [],
      experienceLevel: json['experienceLevel'] as String? ?? '',
      estCookingTime: json['estCookingTime'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mealType: json['mealType'] as String? ?? '',
      cuisine: json['cuisine'] as String? ?? '',
      calorie: (json['calorie'] as num?)?.toInt() ?? 0,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List<dynamic>)
          : [],
      nutrition: json['nutrition'] != null
          ? NutritionModel.fromJson(json['nutrition'] as Map<String, dynamic>)
          : null,
      servings: (json['servings'] as num?)?.toInt() ?? 0,
      addedAt: json['addedAt'] != null
          ? DateTime.tryParse(json['addedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert model to entity
  CookbookRecipeEntity toEntity() {
    return CookbookRecipeEntity(
      userRecipeId: userRecipeId,
      userId: userId,
      originalRecipeId: originalRecipeId,
      originalGeneratedBy: originalGeneratedBy,
      recipeName: recipeName,
      ingredients: ingredients.map((e) => e.toEntity()).toList(),
      steps: steps,
      initialPreparation: initialPreparation,
      kitchenTools: KitchenToolModel.toEntityList(kitchenTools),
      experienceLevel: experienceLevel,
      estCookingTime: estCookingTime,
      description: description,
      mealType: mealType,
      cuisine: cuisine,
      calorie: calorie,
      images: images,
      nutrition: nutrition?.toEntity(),
      servings: servings,
      addedAt: addedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from entity
  factory CookbookRecipeModel.fromEntity(CookbookRecipeEntity entity) {
    return CookbookRecipeModel(
      userRecipeId: entity.userRecipeId,
      userId: entity.userId,
      originalRecipeId: entity.originalRecipeId,
      originalGeneratedBy: entity.originalGeneratedBy,
      recipeName: entity.recipeName,
      ingredients: entity.ingredients
          .map((e) => IngredientModel.fromEntity(e))
          .toList(),
      steps: entity.steps.map((e) => InstructionModel.fromEntity(e)).toList(),
      initialPreparation: entity.initialPreparation
          .map((e) => InitialPreparationModel.fromEntity(e))
          .toList(),
      kitchenTools: entity.kitchenTools
          .map((e) => KitchenToolModel.fromEntity(e))
          .toList(),
      experienceLevel: entity.experienceLevel,
      estCookingTime: entity.estCookingTime,
      description: entity.description,
      mealType: entity.mealType,
      cuisine: entity.cuisine,
      calorie: entity.calorie,
      images: entity.images,
      nutrition: entity.nutrition != null
          ? NutritionModel.fromEntity(entity.nutrition!)
          : null,
      servings: entity.servings,
      addedAt: entity.addedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Create list of models from JSON list
  static List<CookbookRecipeModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map(
          (json) => CookbookRecipeModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  CookbookRecipeModel copyWith({
    String? userRecipeId,
    String? userId,
    String? originalRecipeId,
    String? originalGeneratedBy,
    String? recipeName,
    List<IngredientModel>? ingredients,
    List<InstructionModel>? steps,
    List<InitialPreparationModel>? initialPreparation,
    List<KitchenToolModel>? kitchenTools,
    String? experienceLevel,
    String? estCookingTime,
    String? description,
    String? mealType,
    String? cuisine,
    int? calorie,
    List<String>? images,
    NutritionModel? nutrition,
    int? servings,
    DateTime? addedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CookbookRecipeModel(
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
}
