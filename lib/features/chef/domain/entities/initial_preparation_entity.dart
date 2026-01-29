class InitialPreparationEntity {
  final String id;
  final String step;
  final bool isDone;

  const InitialPreparationEntity({
    required this.id,
    required this.step,
    required this.isDone,
  });

  InitialPreparationEntity copyWith({String? id, String? step, bool? isDone}) {
    return InitialPreparationEntity(
      id: id ?? this.id,
      step: step ?? this.step,
      isDone: isDone ?? this.isDone,
    );
  }
}
