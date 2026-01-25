import '../../domain/entities/kitchen_tool_entity.dart';

class KitchenToolModel {
  final String id;
  final String name;
  final String prefixImage;

  const KitchenToolModel({
    required this.id,
    required this.name,
    required this.prefixImage,
  });

  // toJson - converts model to JSON map
  Map<String, dynamic> toJson() {
    return {'toolId': id, 'toolName': name, 'imageUrl': prefixImage};
  }

  // fromJson - creates model from JSON map
  factory KitchenToolModel.fromJson(Map<String, dynamic> json) {
    return KitchenToolModel(
      id: json['toolId'] as String? ?? '',
      name: json['toolName'] as String? ?? '',
      prefixImage: json['imageUrl'] as String? ?? '',
    );
  }

  // toEntity - converts model to entity
  KitchenToolEntity toEntity() {
    return KitchenToolEntity(toolId: id, toolName: name, imageUrl: prefixImage);
  }

  // fromEntity - creates model from entity
  factory KitchenToolModel.fromEntity(KitchenToolEntity entity) {
    return KitchenToolModel(
      id: entity.toolId,
      name: entity.toolName,
      prefixImage: entity.imageUrl,
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
