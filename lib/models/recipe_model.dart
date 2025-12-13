// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:yumm_ai/models/ingredients_model.dart';

class RecipeModel {
  final String recipeId;
  final String generatedBy;
  final String recipeTitle;
  final List<IngredientsModel> ingredients;
  final String chefType;
  final List<String> steps;
  final List<String> tools;
  final String experienceLevel;
  final Duration availableCookingTime;
  final String estimatedCookingDuration;
  final String cuisine;
  final String estimatedCalorie;
  final String mealType;
  final DateTime createdAt;
  final DateTime updatedAt;
  RecipeModel({
    required this.recipeId,
    required this.generatedBy,
    required this.recipeTitle,
    required this.ingredients,
    required this.chefType,
    required this.steps,
    required this.tools,
    required this.experienceLevel,
    required this.availableCookingTime,
    required this.estimatedCookingDuration,
    required this.cuisine,
    required this.estimatedCalorie,
    required this.mealType,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recipeId': recipeId,
      'generatedBy': generatedBy,
      'recipeTitle': recipeTitle,
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'chefType': chefType,
      'steps': steps,
      'tools': tools,
      'experienceLevel': experienceLevel,
      'availableCookingTime': availableCookingTime.inSeconds,
      'estimatedCookingDuration': estimatedCookingDuration,
      'cuisine': cuisine,
      'estimatedCalorie': estimatedCalorie,
      'mealType': mealType,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      recipeId: map['recipeId'] as String,
      generatedBy: map['generatedBy'] as String,
      recipeTitle: map['recipeTitle'] as String,
      ingredients: List<IngredientsModel>.from(
        (map['ingredients'] as List<int>).map<IngredientsModel>(
          (x) => IngredientsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      chefType: map['chefType'] as String,
      steps: List<String>.from((map['steps'] as List<String>)),
      tools: List<String>.from((map['tools'] as List<String>)),
      experienceLevel: map['experienceLevel'] as String,
      // Recreate duration from stored seconds
      availableCookingTime: Duration(
        seconds: (map['availableCookingTime'] as num).toInt(),
      ),
      estimatedCookingDuration: map['estimatedCookingDuration'] as String,
      cuisine: map['cuisine'] as String,
      estimatedCalorie: map['estimatedCalorie'] as String,
      mealType: map['mealType'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(String source) =>
      RecipeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecipeModel(recipeId: $recipeId, generatedBy: $generatedBy, recipeTitle: $recipeTitle, ingredients: $ingredients, chefType: $chefType, steps: $steps, tools: $tools, experienceLevel: $experienceLevel, availableCookingTime: $availableCookingTime, estimatedCookingDuration: $estimatedCookingDuration, cuisine: $cuisine, estimatedCalorie: $estimatedCalorie, mealType: $mealType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  RecipeModel copyWith({
    String? recipeId,
    String? generatedBy,
    String? recipeTitle,
    List<IngredientsModel>? ingredients,
    String? chefType,
    List<String>? steps,
    List<String>? tools,
    String? experienceLevel,
    Duration? availableCookingTime,
    String? estimatedCookingDuration,
    String? cuisine,
    String? estimatedCalorie,
    String? mealType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecipeModel(
      recipeId: recipeId ?? this.recipeId,
      generatedBy: generatedBy ?? this.generatedBy,
      recipeTitle: recipeTitle ?? this.recipeTitle,
      ingredients: ingredients ?? this.ingredients,
      chefType: chefType ?? this.chefType,
      steps: steps ?? this.steps,
      tools: tools ?? this.tools,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      availableCookingTime: availableCookingTime ?? this.availableCookingTime,
      estimatedCookingDuration:
          estimatedCookingDuration ?? this.estimatedCookingDuration,
      cuisine: cuisine ?? this.cuisine,
      estimatedCalorie: estimatedCalorie ?? this.estimatedCalorie,
      mealType: mealType ?? this.mealType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
