import '../../domain/entities/kitchen_tool_entity.dart';

class KitchenToolModel {
  final String toolId;
  final String toolName;
  final String imageUrl;
  final bool isReady;

  const KitchenToolModel({
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
  factory KitchenToolModel.fromJson(Map<String, dynamic> json) {
    return KitchenToolModel(
      toolId: json['toolId'] as String? ?? '',
      toolName: json['toolName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      isReady: json['isReady'] as bool? ?? false,
    );
  }

  // toEntity - converts model to entity
  KitchenToolEntity toEntity() {
    return KitchenToolEntity(
      toolId: toolId,
      toolName: toolName,
      imageUrl: imageUrl,
      isReady: isReady,
    );
  }

  // fromEntity - creates model from entity
  factory KitchenToolModel.fromEntity(KitchenToolEntity entity) {
    return KitchenToolModel(
      toolId: entity.toolId,
      toolName: entity.toolName,
      imageUrl: entity.imageUrl,
      isReady: entity.isReady,
    );
  }

  // toEntityList - converts list of models to list of entities
  static List<KitchenToolEntity> toEntityList(List<KitchenToolModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  // fromJsonList - creates list of models from JSON list
  static List<KitchenToolModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => KitchenToolModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
