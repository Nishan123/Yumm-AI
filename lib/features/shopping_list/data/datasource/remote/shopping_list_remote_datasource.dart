import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/features/shopping_list/data/datasource/shopping_list_datasource.dart';
import 'package:yumm_ai/features/shopping_list/data/model/shopping_list_api_model.dart';

final shoppingListRemoteDatasourceProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ShoppingListRemoteDatasource(apiClient: apiClient);
});

class ShoppingListRemoteDatasource implements IShoppingListRemoteDatasource {
  final ApiClient _apiClient;

  ShoppingListRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<ShoppingListApiModel> addItem(ShoppingListApiModel item) async {
    final response = await _apiClient.post(
      ApiEndpoints.addShoppingListItem,
      data: item.toJson(),
    );
    if (response.data['success']) {
      final data = response.data['data'] as Map<String, dynamic>;
      return ShoppingListApiModel.fromJson(data);
    }
    throw Exception(response.data['message'] ?? 'Failed to add item');
  }

  @override
  Future<List<ShoppingListApiModel>> getItems({String? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null && category != 'any') {
      queryParams['category'] = category;
    }
    final response = await _apiClient.get(
      ApiEndpoints.getShoppingList,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    if (response.data['success']) {
      final data = response.data['data'] as List;
      return data
          .map((e) => ShoppingListApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(response.data['message'] ?? 'Failed to fetch items');
  }

  @override
  Future<ShoppingListApiModel> updateItem(ShoppingListApiModel item) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateShoppingListItem(item.itemId!),
      data: item.toJson(),
    );
    if (response.data['success']) {
      final data = response.data['data'] as Map<String, dynamic>;
      return ShoppingListApiModel.fromJson(data);
    }
    throw Exception(response.data['message'] ?? 'Failed to update item');
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    final response = await _apiClient.delete(
      ApiEndpoints.deleteShoppingListItem(itemId),
    );
    if (response.data['success']) {
      return true;
    }
    throw Exception(response.data['message'] ?? 'Failed to delete item');
  }
}
