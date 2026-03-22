import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';

abstract interface class IRemoteKitchenToolDatasource{
  Future<KitchenToolModel?> saveKitchenTool({required KitchenToolModel kitchenTool});
  Future<bool> deleteKitchenTool({required String uid, required String toolId});
  Future<List<KitchenToolModel>> getUserKithcenTools({required String uid});
}