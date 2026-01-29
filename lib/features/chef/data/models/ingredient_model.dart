import '../../domain/entities/ingredient_entity.dart';

class IngredientModel {
  final String ingredientId;
  final String name;
  final String imageUrl;
  final String quantity;
  final String unit;
  final bool isReady;

  const IngredientModel({
    required this.ingredientId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.unit,
    required this.isReady,
  });

  // toJson - converts model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
      'name': name,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'unit': unit,
      'isReady': isReady,
    };
  }

  // fromJson - creates model from JSON map
  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      ingredientId: (json['ingredientId'] ?? json['id']) as String? ?? '',
      name: (json['name'] ?? json['ingredientName']) as String? ?? '',
      imageUrl: (json['imageUrl'] ?? json['prefixImage']) as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      isReady: json['isReady'] as bool? ?? false,
    );
  }

  // toEntity - converts model to entity
  IngredientEntity toEntity() {
    return IngredientEntity(
      ingredientId: ingredientId,
      name: name,
      imageUrl: imageUrl,
      quantity: quantity,
      unit: unit,
      isReady: isReady,
    );
  }

  // fromEntity - creates model from entity
  factory IngredientModel.fromEntity(IngredientEntity entity) {
    return IngredientModel(
      ingredientId: entity.ingredientId,
      name: entity.name,
      imageUrl: entity.imageUrl,
      quantity: entity.quantity,
      unit: entity.unit,
      isReady: entity.isReady,
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
    List<IngredientModel> masterIngredients,
  ) {
    // Try to get id and ingredientName directly from AI response
    final aiId = json['id'] as String? ?? '';
    final aiIngredientName = (json['ingredientName'] as String? ?? '').trim();
    final quantity = json['quantity']?.toString() ?? '';
    final unit = json['unit'] as String? ?? '';

    // 1. First try to find by id in USER REFERENCE ingredients (selected by user)
    // We prioritize this because the user explicitly selected these.
    if (aiId.isNotEmpty) {
      final matchById = referenceIngredients
          .cast<IngredientModel?>()
          .firstWhere((ing) => ing!.ingredientId == aiId, orElse: () => null);
      if (matchById != null) {
        return IngredientModel(
          ingredientId: matchById.ingredientId,
          name: matchById.name,
          imageUrl: matchById.imageUrl,
          quantity: quantity,
          unit: unit,
          isReady: false,
        );
      }
    }

    // 2. Fallback: find by ingredientName in USER REFERENCE ingredients
    final matchByName = referenceIngredients
        .cast<IngredientModel?>()
        .firstWhere(
          (ing) => ing!.name.toLowerCase() == aiIngredientName.toLowerCase(),
          orElse: () => null,
        );

    if (matchByName != null) {
      return IngredientModel(
        ingredientId: matchByName.ingredientId,
        name: matchByName.name,
        imageUrl: matchByName.imageUrl,
        quantity: quantity,
        unit: unit,
        isReady: false,
      );
    }
    if (aiId.isNotEmpty) {
      final matchInMasterById = masterIngredients
          .cast<IngredientModel?>()
          .firstWhere((ing) => ing!.ingredientId == aiId, orElse: () => null);

      if (matchInMasterById != null) {
        return IngredientModel(
          ingredientId: matchInMasterById.ingredientId,
          name: matchInMasterById.name,
          imageUrl: matchInMasterById.imageUrl,
          quantity: quantity,
          unit: unit,
          isReady: false,
        );
      }
    }

    // Check by Name in Master List
    final matchInMasterByName = masterIngredients
        .cast<IngredientModel?>()
        .firstWhere(
          (ing) => ing!.name.toLowerCase() == aiIngredientName.toLowerCase(),
          orElse: () => null,
        );

    if (matchInMasterByName != null) {
      return IngredientModel(
        ingredientId: matchInMasterByName.ingredientId,
        name: matchInMasterByName.name,
        imageUrl: matchInMasterByName.imageUrl,
        quantity: quantity,
        unit: unit,
        isReady: false,
      );
    }

    return IngredientModel(
      ingredientId: aiId.isNotEmpty
          ? aiId
          : 'ai_${aiIngredientName.replaceAll(' ', '_').toLowerCase()}',
      name: aiIngredientName,
      imageUrl: '', // No image available for unknown ingredients
      quantity: quantity,
      unit: unit,
      isReady: false,
    );
  }

  /// Creates a list of IngredientModels from AI response by mapping each to real ingredient data.
  static List<IngredientModel> fromAiResponseList(
    List<dynamic> jsonList,
    List<IngredientModel> referenceIngredients,
    List<IngredientModel> masterIngredients,
  ) {
    return jsonList
        .map(
          (json) => IngredientModel.fromAiResponse(
            json as Map<String, dynamic>,
            referenceIngredients,
            masterIngredients,
          ),
        )
        .toList();
  }
}
