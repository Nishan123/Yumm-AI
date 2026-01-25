import '../../../kitchen_tool/data/models/kitchen_tools_model.dart';
import '../../domain/entities/recipe_entity.dart';
import 'Ingrident_model.dart';
import 'nutrition_model.dart';

class RecipeModel {
  final String recipeId;
  final String generatedBy;
  final String recipeName;
  final List<IngredientModel> ingredients;
  final List<String> steps;
  final List<String> initialPreparation;
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
  final List<String> likes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RecipeModel({
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

  // toJson - converts model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'generatedBy': generatedBy,
      'recipeName': recipeName,
      'ingridents': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps,
      'initialPrepration': initialPreparation,
      'kitchenTools': kitchenTools.map((e) => e.toJson()).toList(),
      'experienceLevel': experienceLevel,
      'estCookingTime': estCookingTime,
      'description': description,
      'mealType': mealType,
      'cusine': cuisine,
      'calorie': calorie,
      'images': images,
      'nutrition': nutrition?.toJson(),
      'servings': servings,
      'likes': likes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // fromJson - creates model from JSON map
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      recipeId: json['recipeId'] as String? ?? '',
      generatedBy: json['generatedBy'] as String? ?? '',
      recipeName: json['recipeName'] as String? ?? '',
      ingredients: json['ingridents'] != null
          ? IngredientModel.fromJsonList(json['ingridents'] as List<dynamic>)
          : [],
      steps: json['steps'] != null
          ? List<String>.from(json['steps'] as List<dynamic>)
          : [],
      initialPreparation: json['initialPrepration'] != null
          ? List<String>.from(json['initialPrepration'] as List<dynamic>)
          : [],
      kitchenTools: json['kitchenTools'] != null
          ? KitchenToolModel.fromJsonList(json['kitchenTools'] as List<dynamic>)
          : [],
      experienceLevel: json['experienceLevel'] as String? ?? '',
      estCookingTime: json['estCookingTime'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mealType: json['mealType'] as String? ?? '',
      cuisine: json['cusine'] as String? ?? '',
      calorie: (json['calorie'] as num?)?.toInt() ?? 0,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List<dynamic>)
          : [],
      nutrition: json['nutrition'] != null
          ? NutritionModel.fromJson(json['nutrition'] as Map<String, dynamic>)
          : null,
      servings: (json['servings'] as num?)?.toInt() ?? 0,
      likes: json['likes'] != null
          ? List<String>.from(json['likes'] as List<dynamic>)
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Creates a RecipeModel from AI response JSON by mapping ingredients to real data.
  ///
  /// Use this factory when parsing AI-generated recipe responses where ingredients
  /// only contain `name`, `quantity`, and `unit`. The [referenceIngredients] list
  /// provides the real `id` and `prefixImage` for each ingredient.
  factory RecipeModel.fromAiJson(
    Map<String, dynamic> json,
    List<IngredientModel> referenceIngredients,
  ) {
    return RecipeModel(
      recipeId: json['recipeId'] as String? ?? '',
      generatedBy: json['generatedBy'] as String? ?? '',
      recipeName: json['recipeName'] as String? ?? '',
      ingredients: json['ingridents'] != null
          ? IngredientModel.fromAiResponseList(
              json['ingridents'] as List<dynamic>,
              referenceIngredients,
            )
          : [],
      steps: json['steps'] != null
          ? List<String>.from(json['steps'] as List<dynamic>)
          : [],
      initialPreparation: json['initialPrepration'] != null
          ? List<String>.from(json['initialPrepration'] as List<dynamic>)
          : [],
      kitchenTools: json['kitchenTools'] != null
          ? KitchenToolModel.fromJsonList(json['kitchenTools'] as List<dynamic>)
          : [],
      experienceLevel: json['experienceLevel'] as String? ?? '',
      estCookingTime: json['estCookingTime'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mealType: json['mealType'] as String? ?? '',
      cuisine: json['cusine'] as String? ?? '',
      calorie: (json['calorie'] as num?)?.toInt() ?? 0,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List<dynamic>)
          : [],
      nutrition: json['nutrition'] != null
          ? NutritionModel.fromJson(json['nutrition'] as Map<String, dynamic>)
          : null,
      servings: (json['servings'] as num?)?.toInt() ?? 0,
      likes: json['likes'] != null
          ? List<String>.from(json['likes'] as List<dynamic>)
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  // toEntity - converts model to entity
  RecipeEntity toEntity() {
    return RecipeEntity(
      recipeId: recipeId,
      generatedBy: generatedBy,
      recipeName: recipeName,
      ingredients: IngredientModel.toEntityList(ingredients),
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
      likes: likes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // fromEntity - creates model from entity
  factory RecipeModel.fromEntity(RecipeEntity entity) {
    return RecipeModel(
      recipeId: entity.recipeId,
      generatedBy: entity.generatedBy,
      recipeName: entity.recipeName,
      ingredients: entity.ingredients
          .map((e) => IngredientModel.fromEntity(e))
          .toList(),
      steps: entity.steps,
      initialPreparation: entity.initialPreparation,
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
      likes: entity.likes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // toEntityList - converts list of models to list of entities
  static List<RecipeEntity> toEntityList(List<RecipeModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  // fromJsonList - creates list of models from JSON list
  static List<RecipeModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => RecipeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
