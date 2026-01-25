class NutritionEntity {
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  const NutritionEntity({
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionEntity &&
          runtimeType == other.runtimeType &&
          protein == other.protein &&
          carbs == other.carbs &&
          fat == other.fat &&
          fiber == other.fiber;

  @override
  int get hashCode =>
      protein.hashCode ^ carbs.hashCode ^ fat.hashCode ^ fiber.hashCode;
}
