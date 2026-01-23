import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:yumm_ai/features/chef/data/Ingrident_model.dart';

class IngredientController {
  Future<List<IngredientModel>> getIngredients() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/ingridents.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final validItems = jsonList.where((item) =>
        item is Map &&
        item['ingredientName'] != null &&
        item['prefixImage'] != null);

    return validItems
        .map((json) => IngredientModel.fromMap(json as Map<String, dynamic>))
        .toList();
  }
}