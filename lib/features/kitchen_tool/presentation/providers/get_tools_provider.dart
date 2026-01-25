import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/usecases/kitchen_tools_usecase.dart';

final getToolsProvider = FutureProvider<List<KitchenToolModel>>((ref) {
  return KitchenToolsUsecase().getTools();
});
