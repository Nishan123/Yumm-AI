class IngredientEntity {
  final String ingredientId;
  final String name;
  final String imageUrl;
  final String quantity;
  final String unit;

  const IngredientEntity({
    required this.ingredientId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.unit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientEntity &&
          runtimeType == other.runtimeType &&
          ingredientId == other.ingredientId &&
          name == other.name &&
          imageUrl == other.imageUrl &&
          quantity == other.quantity &&
          unit == other.unit;

  @override
  int get hashCode =>
      ingredientId.hashCode ^
      name.hashCode ^
      imageUrl.hashCode ^
      quantity.hashCode ^
      unit.hashCode;
}
