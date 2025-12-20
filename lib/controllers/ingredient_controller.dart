import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yumm_ai/models/ingredients_model.dart';

class IngredientController {
  Future<List<IngredientsModel>> getIngredients() async {
    final String jsonString = await rootBundle.loadString(
      'assets/ingridents.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final validItems = jsonList.where((item) =>
        item is Map &&
        item['ingredientName'] != null &&
        item['prefixImage'] != null);

    return validItems
        .map((json) => IngredientsModel.fromMap(json as Map<String, dynamic>))
        .toList();
  }
}
