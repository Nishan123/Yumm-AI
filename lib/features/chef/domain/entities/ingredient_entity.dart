class IngredientEntity {
  final String ingredientId;
  final String name;
  final String imageUrl;
  final String quantity;
  final String unit;
  final bool isReady;

  const IngredientEntity({
    required this.ingredientId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.unit,
    required this.isReady,
  });

  IngredientEntity copyWith({
    String? ingredientId,
    String? name,
    String? imageUrl,
    String? quantity,
    String? unit,
    bool? isReady,
  }) {
    return IngredientEntity(
      ingredientId: ingredientId ?? this.ingredientId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isReady: isReady ?? this.isReady,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientEntity &&
          runtimeType == other.runtimeType &&
          ingredientId == other.ingredientId &&
          name == other.name &&
          imageUrl == other.imageUrl &&
          quantity == other.quantity &&
          unit == other.unit &&
          isReady == other.isReady;

  @override
  int get hashCode =>
      ingredientId.hashCode ^
      name.hashCode ^
      imageUrl.hashCode ^
      quantity.hashCode ^
      unit.hashCode ^
      isReady.hashCode;
}
