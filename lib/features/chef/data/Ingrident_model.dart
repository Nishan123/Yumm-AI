import 'dart:convert';

class IngredientModel {
  final String id;
  final String prefixImage;
  final String ingredientName;
  IngredientModel({
    required this.id,
    required this.prefixImage,
    required this.ingredientName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'prefixImage': prefixImage,
      'ingredientName': ingredientName,
    };
  }

  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
      id: map['id'] as String,
      prefixImage: map['prefixImage'] as String,
      ingredientName: map['ingredientName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IngredientModel.fromJson(String source) =>
      IngredientModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
