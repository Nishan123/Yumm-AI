import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';

class ShoppingListApiModel {
  final String? itemId;
  final String? userId;
  final String quantity;
  final String unit;
  final String category;
  final bool isChecked;
  final String? ingredientId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShoppingListApiModel({
    this.itemId,
    this.userId,
    required this.quantity,
    required this.unit,
    this.category = 'none',
    this.isChecked = false,
    this.ingredientId,
    this.createdAt,
    this.updatedAt,
  });

  // from json
  factory ShoppingListApiModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return ShoppingListApiModel(
      itemId: json['itemId'] as String?,
      userId: json['userId'] as String?,
      quantity: (json['quantity'] ?? '') as String,
      unit: (json['unit'] ?? '') as String,
      category: (json['category'] ?? 'none') as String,
      isChecked: (json['isChecked'] ?? false) as bool,
      ingredientId: json['ingredientId'] as String?,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'itemId': itemId,
      'userId': userId,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'isChecked': isChecked,
      'ingredientId': ingredientId,
    };
    return json;
  }

  // to entity
  ShoppingListEntity toEntity() {
    return ShoppingListEntity(
      itemId: itemId,
      userId: userId,
      quantity: quantity,
      unit: unit,
      category: category,
      isChecked: isChecked,
      ingredientId: ingredientId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // from entity
  factory ShoppingListApiModel.fromEntity(ShoppingListEntity entity) {
    return ShoppingListApiModel(
      itemId: entity.itemId,
      userId: entity.userId,
      quantity: entity.quantity,
      unit: entity.unit,
      category: entity.category,
      isChecked: entity.isChecked,
      ingredientId: entity.ingredientId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
