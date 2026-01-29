import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/domain/repositories/ingredient_repository.dart';

final ingredientRepositoryProvider = Provider<IngredientRepository>((ref) {
  return IngredientRepositoryImpl();
});

class IngredientRepositoryImpl implements IngredientRepository {
  @override
  Future<List<IngredientModel>> getIngredients() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/ingridents.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final validItems = jsonList.where(
      (item) =>
          item is Map &&
          item['ingredientName'] != null &&
          item['prefixImage'] != null,
    );

    return validItems
        .map((json) => IngredientModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
