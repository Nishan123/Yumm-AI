import 'package:yumm_ai/features/food_pref/domain/entity/food_pref_entity.dart';

class FoodPrefApiModel {
  final String prefId;
  final String ownerId;
  final List<String> preferences;

  FoodPrefApiModel({
    required this.prefId,
    required this.ownerId,
    required this.preferences,
  });

  FoodPrefApiModel copyWith({
    String? prefId,
    String? ownerId,
    List<String>? preferences,
  }) {
    return FoodPrefApiModel(
      prefId: prefId ?? this.prefId,
      ownerId: ownerId ?? this.ownerId,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toJson() {
    return {'prefId': prefId, 'ownerId': ownerId, 'preferences': preferences};
  }

  factory FoodPrefApiModel.fromJson(Map<String, dynamic> json) {
    return FoodPrefApiModel(
      prefId: json['prefId'],
      ownerId: json['ownerId'],
      preferences: json['preferences'],
    );
  }

  FoodPrefEntity toEntity() {
    return FoodPrefEntity(
      prefId: prefId,
      ownerId: ownerId,
      preferences: preferences,
    );
  }

  factory FoodPrefApiModel.fromEntity(FoodPrefEntity entity) {
    return FoodPrefApiModel(
      prefId: entity.prefId,
      ownerId: entity.ownerId,
      preferences: entity.preferences,
    );
  }
}
