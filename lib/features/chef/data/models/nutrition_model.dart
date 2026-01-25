import '../../domain/entities/nutrition_entity.dart';

class NutritionModel {
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  const NutritionModel({
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });

  // toJson - converts model to JSON map
  Map<String, dynamic> toJson() {
    return {'protein': protein, 'carbs': carbs, 'fat': fat, 'fiber': fiber};
  }

  // fromJson - creates model from JSON map
  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // toEntity - converts model to entity
  NutritionEntity toEntity() {
    return NutritionEntity(
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
    );
  }

  // fromEntity - creates model from entity
  factory NutritionModel.fromEntity(NutritionEntity entity) {
    return NutritionModel(
      protein: entity.protein,
      carbs: entity.carbs,
      fat: entity.fat,
      fiber: entity.fiber,
    );
  }
}
