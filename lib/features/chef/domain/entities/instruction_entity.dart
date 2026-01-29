class InstructionEntity {
  final String instructionId;
  final String instruction;
  final bool isDone;

  const InstructionEntity({
    required this.instructionId,
    required this.instruction,
    required this.isDone,
  });

  InstructionEntity copyWith({
    String? instructionId,
    String? instruction,
    bool? isDone,
  }) {
    return InstructionEntity(
      instructionId: instructionId ?? this.instructionId,
      instruction: instruction ?? this.instruction,
      isDone: isDone ?? this.isDone,
    );
  }
}
