import '../../domain/entities/initial_preparation_entity.dart';

class InitialPreparationModel extends InitialPreparationEntity {
  const InitialPreparationModel({
    required super.id,
    required super.step,
    required super.isDone,
  });

  factory InitialPreparationModel.fromJson(Map<String, dynamic> json) {
    return InitialPreparationModel(
      id: json['id'] as String? ?? '',
      step: json['instruction'] as String? ?? '',
      isDone: json['isDone'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'instruction': step, 'isDone': isDone};
  }

  factory InitialPreparationModel.fromEntity(InitialPreparationEntity entity) {
    return InitialPreparationModel(
      id: entity.id,
      step: entity.step,
      isDone: entity.isDone,
    );
  }

  static List<InitialPreparationModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map(
          (json) =>
              InitialPreparationModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
