import 'dart:convert';

class IngredientsModel {
  final String id;
  final String prefixImage;
  final String ingredientName;
  IngredientsModel({
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

  factory IngredientsModel.fromMap(Map<String, dynamic> map) {
    return IngredientsModel(
      id: map['id'] as String,
      prefixImage: map['prefixImage'] as String,
      ingredientName: map['ingredientName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IngredientsModel.fromJson(String source) => IngredientsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
