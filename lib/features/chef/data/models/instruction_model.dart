import '../../domain/entities/instruction_entity.dart';

class InstructionModel extends InstructionEntity {
  const InstructionModel({
    required super.instructionId,
    required super.instruction,
    required super.isDone,
  });

  factory InstructionModel.fromJson(Map<String, dynamic> json) {
    return InstructionModel(
      instructionId:
          json['id'] as String? ?? "",
      instruction:
          json['instruction'] as String? ?? "",
      isDone: json['isDone'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': instructionId, 'instruction': instruction, 'isDone': isDone};
  }

  factory InstructionModel.fromEntity(InstructionEntity entity) {
    return InstructionModel(
      instructionId: entity.instructionId,
      instruction: entity.instruction,
      isDone: entity.isDone,
    );
  }

  static List<InstructionModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => InstructionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static List<InstructionEntity> toEntityList(List<InstructionModel> models) {
    return models;
  }
}
