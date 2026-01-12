import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';

class KitchenToolsUsecase {
  Future<List<KitchenToolsModel>> getTools() async {
    final String jsonString = await rootBundle.loadString(
      'assets/kitchen_tools.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    final List<KitchenToolsModel> tools = [];
    for (var i = 0; i < jsonList.length; i++) {
      final item = jsonList[i];
      if (item is Map && item['name'] != null && item['prefixImage'] != null) {
        final id = (item['id'] ?? i).toString();
        final name = item['name'].toString();
        final prefixImage = item['prefixImage'].toString();
        tools.add(
          KitchenToolsModel(id: id, name: name, prefixImage: prefixImage),
        );
      }
    }

    return tools;
  }
}
