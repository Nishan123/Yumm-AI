import 'dart:convert';

class KitchenToolsModel {
  final String id;
  final String name;
  final String prefixImage;
  KitchenToolsModel({
    required this.id,
    required this.name,
    required this.prefixImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'prefixImage': prefixImage,
    };
  }

  factory KitchenToolsModel.fromMap(Map<String, dynamic> map) {
    return KitchenToolsModel(
      id: map['id'] as String,
      name: map['name'] as String,
      prefixImage: map['prefixImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory KitchenToolsModel.fromJson(String source) => KitchenToolsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
