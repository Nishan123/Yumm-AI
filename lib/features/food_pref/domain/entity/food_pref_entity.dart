import 'package:equatable/equatable.dart';

class FoodPrefEntity extends Equatable {
  final String prefId;
  final String ownerId;
  final List<String> preferences;
  const FoodPrefEntity({
    required this.prefId,
    required this.ownerId,
    required this.preferences,
  });

  FoodPrefEntity copyWith({
    String? prefId,
    String? ownerId,
    List<String>? preferences,
  }) {
    return FoodPrefEntity(
      prefId: prefId ?? this.prefId,
      ownerId: ownerId ?? this.ownerId,
      preferences: preferences ?? this.preferences,
    );
  }
  
  @override
  List<Object?> get props => [prefId, ownerId, preferences];
}
