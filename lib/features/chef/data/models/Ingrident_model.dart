import '../../domain/entities/ingredient_entity.dart';

class IngredientModel {
  final String id;
  final String ingredientName;
  final String prefixImage;
  final String quantity;
  final String unit;

  const IngredientModel({
    required this.id,
    required this.ingredientName,
    required this.prefixImage,
    required this.quantity,
    required this.unit,
  });

  // toJson - converts model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'ingridentId': id,
      'name': ingredientName,
      'imageUrl': prefixImage,
      'quantity': quantity,
      'unit': unit,
    };
  }

  // fromJson - creates model from JSON map
  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: (json['ingridentId'] ?? json['id']) as String? ?? '',
      ingredientName: (json['name'] ?? json['ingredientName']) as String? ?? '',
      prefixImage: (json['imageUrl'] ?? json['prefixImage']) as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
    );
  }

  // toEntity - converts model to entity
  IngredientEntity toEntity() {
    return IngredientEntity(
      ingredientId: id,
      name: ingredientName,
      imageUrl: prefixImage,
      quantity: quantity,
      unit: unit,
    );
  }

  // fromEntity - creates model from entity
  factory IngredientModel.fromEntity(IngredientEntity entity) {
    return IngredientModel(
      id: entity.ingredientId,
      ingredientName: entity.name,
      prefixImage: entity.imageUrl,
      quantity: entity.quantity,
      unit: entity.unit,
    );
  }

  // toEntityList - converts list of models to list of entities
  static List<IngredientEntity> toEntityList(List<IngredientModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  // fromJsonList - creates list of models from JSON list
  static List<IngredientModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => IngredientModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Creates an IngredientModel from AI response JSON by mapping to real ingredient data.
  factory IngredientModel.fromAiResponse(
    Map<String, dynamic> json,
    List<IngredientModel> referenceIngredients,
  ) {
    // Try to get id and ingredientName directly from AI response
    final aiId = json['id'] as String? ?? '';
    final aiIngredientName = (json['ingredientName'] as String? ?? '').trim();
    final quantity = json['quantity']?.toString() ?? '';
    final unit = json['unit'] as String? ?? '';

    // First try to find by id
    if (aiId.isNotEmpty) {
      final matchById = referenceIngredients
          .cast<IngredientModel?>()
          .firstWhere((ing) => ing!.id == aiId, orElse: () => null);
      if (matchById != null) {
        return IngredientModel(
          id: matchById.id,
          ingredientName: matchById.ingredientName,
          prefixImage: matchById.prefixImage,
          quantity: quantity,
          unit: unit,
        );
      }
    }

    // Fallback: find by ingredientName (case-insensitive)
    final matchByName = referenceIngredients
        .cast<IngredientModel?>()
        .firstWhere(
          (ing) =>
              ing!.ingredientName.toLowerCase() ==
              aiIngredientName.toLowerCase(),
          orElse: () => null,
        );

    if (matchByName != null) {
      return IngredientModel(
        id: matchByName.id,
        ingredientName: matchByName.ingredientName,
        prefixImage: matchByName.prefixImage,
        quantity: quantity,
        unit: unit,
      );
    }

    // Last resort: create new ingredient model with AI-provided data
    return IngredientModel(
      id: aiId.isNotEmpty
          ? aiId
          : 'ai_${aiIngredientName.replaceAll(' ', '_').toLowerCase()}',
      ingredientName: aiIngredientName,
      prefixImage: '',
      quantity: quantity,
      unit: unit,
    );
  }

  /// Creates a list of IngredientModels from AI response by mapping each to real ingredient data.
  static List<IngredientModel> fromAiResponseList(
    List<dynamic> jsonList,
    List<IngredientModel> referenceIngredients,
  ) {
    return jsonList
        .map(
          (json) => IngredientModel.fromAiResponse(
            json as Map<String, dynamic>,
            referenceIngredients,
          ),
        )
        .toList();
  }
}
