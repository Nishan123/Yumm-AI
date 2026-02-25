import 'package:yumm_ai/features/shopping_list/data/model/shopping_list_api_model.dart';

abstract interface class IShoppingListRemoteDatasource {
  Future<ShoppingListApiModel> addItem(ShoppingListApiModel item);
  Future<List<ShoppingListApiModel>> getItems({String? category});
  Future<ShoppingListApiModel> updateItem(ShoppingListApiModel item);
  Future<bool> deleteItem(String itemId);
}
