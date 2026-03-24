import 'package:yumm_ai/features/chef/domain/entities/recipe_kitchen_tool_entity.dart';

class RecipeKitchenToolModel {
  final String toolId;
  final String toolName;
  final String imageUrl;
  final bool isReady;

  const RecipeKitchenToolModel({
    required this.toolId,
    required this.toolName,
    required this.imageUrl,
    this.isReady = false,
  });

  // toJson - converts model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'toolId': toolId,
      'toolName': toolName,
      'imageUrl': imageUrl,
      'isReady': isReady,
    };
  }

  // fromJson - creates model from JSON map
  factory RecipeKitchenToolModel.fromJson(Map<String, dynamic> json) {
    return RecipeKitchenToolModel(
      toolId: json['toolId'] as String? ?? '',
      toolName: json['toolName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      isReady: json['isReady'] as bool? ?? false,
    );
  }

  // toEntity - converts model to entity
  RecipeKitchenToolEntity toEntity() {
    return RecipeKitchenToolEntity(
      toolId: toolId,
      toolName: toolName,
      imageUrl: imageUrl,
      isReady: isReady,
    );
  }

  // fromEntity - creates model from entity
  factory RecipeKitchenToolModel.fromEntity(RecipeKitchenToolEntity entity) {
    return RecipeKitchenToolModel(
      toolId: entity.toolId,
      toolName: entity.toolName,
      imageUrl: entity.imageUrl,
      isReady: entity.isReady,
    );
  }

  // toEntityList - converts list of models to list of entities
  static List<RecipeKitchenToolEntity> toEntityList(List<RecipeKitchenToolModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  // fromJsonList - creates list of models from JSON list
  static List<RecipeKitchenToolModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => RecipeKitchenToolModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
