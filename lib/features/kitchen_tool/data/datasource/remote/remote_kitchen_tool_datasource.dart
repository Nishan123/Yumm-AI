import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/kitchen_tool/data/datasource/kitchen_tool_datasource.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';

final remoteKitchenToolDatasourceProvider = Provider((ref){
  return RemoteKitchenToolDatasource(apiClient: ref.read(apiClientProvider));
});

class RemoteKitchenToolDatasource implements IRemoteKitchenToolDatasource{
  final ApiClient _apiClient;
  RemoteKitchenToolDatasource({
    required ApiClient apiClient
  }):_apiClient=apiClient;
  @override
  Future<bool> deleteKitchenTool({required String uid, required String toolId}) async{
    final response = await _apiClient.delete(ApiEndpoints.deleteKitchenTool(toolId, uid));
    if(response.data["success"]){
      return true;
    }
    throw ApiFailure(message: response.data["message"]);
  }

  @override
  Future<List<KitchenToolModel>> getUserKithcenTools({required String uid}) async{
    final response = await _apiClient.get(ApiEndpoints.getUserKitchenTools(uid));
    if(response.data["success"]){
      return KitchenToolModel.fromJsonList(response.data["data"]["tools"]);
    }
    throw ApiFailure(message: response.data['message']);
  }

  @override
  Future<KitchenToolModel?> saveKitchenTool({required KitchenToolModel kitchenTool}) async{
    final response = await _apiClient.post(ApiEndpoints.saveKitchenTool, data: kitchenTool.toJson());
    if(response.data["success"]){
      return KitchenToolModel.fromJson(response.data["data"]);
    }
    throw ApiFailure(message: response.data["message"]);
  }
  
}