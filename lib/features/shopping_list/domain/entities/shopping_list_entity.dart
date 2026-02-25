import 'package:equatable/equatable.dart';

class ShoppingListEntity extends Equatable {
  final String? itemId;
  final String? userId;
  final String name;
  final String imageUrl;
  final String quantity;
  final String unit;
  final String category;
  final bool isChecked;
  final String? ingredientId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ShoppingListEntity({
    this.itemId,
    this.userId,
    required this.name,
    this.imageUrl = '',
    required this.quantity,
    required this.unit,
    this.category = 'none',
    this.isChecked = false,
    this.ingredientId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    itemId,
    userId,
    name,
    imageUrl,
    quantity,
    unit,
    category,
    isChecked,
    ingredientId,
    createdAt,
    updatedAt,
  ];
}
