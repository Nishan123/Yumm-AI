import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';
import 'package:yumm_ai/features/shopping_list/domain/usecases/add_shopping_list_item_usecase.dart';
import 'package:yumm_ai/features/shopping_list/domain/usecases/delete_shopping_list_item_usecase.dart';
import 'package:yumm_ai/features/shopping_list/domain/usecases/get_shopping_list_usecase.dart';
import 'package:yumm_ai/features/shopping_list/domain/usecases/update_shopping_list_item_usecase.dart';
import 'package:yumm_ai/features/shopping_list/presentation/state/shopping_list_state.dart';

final shoppingListViewModelProvider =
    NotifierProvider<ShoppingListViewModel, ShoppingListState>(
      () => ShoppingListViewModel(),
    );

class ShoppingListViewModel extends Notifier<ShoppingListState> {
  late AddShoppingListItemUsecase _addItemUsecase;
  late GetShoppingListUsecase _getItemsUsecase;
  late UpdateShoppingListItemUsecase _updateItemUsecase;
  late DeleteShoppingListItemUsecase _deleteItemUsecase;

  @override
  ShoppingListState build() {
    _addItemUsecase = ref.read(addShoppingListItemUsecaseProvider);
    _getItemsUsecase = ref.read(getShoppingListUsecaseProvider);
    _updateItemUsecase = ref.read(updateShoppingListItemUsecaseProvider);
    _deleteItemUsecase = ref.read(deleteShoppingListItemUsecaseProvider);
    return const ShoppingListState();
  }

  Future<void> getItems({String? category}) async {
    state = state.copyWith(status: ShoppingListStatus.loading);
    final result = await _getItemsUsecase.call(category);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ShoppingListStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (items) {
        state = state.copyWith(status: ShoppingListStatus.loaded, items: items);
      },
    );
  }

  Future<bool> addItem({
    required String quantity,
    required String unit,
    String category = 'none',
    String? ingredientId,
  }) async {
    state = state.copyWith(status: ShoppingListStatus.adding);
    final params = AddShoppingListItemParam(
      quantity: quantity,
      unit: unit,
      category: category,
      ingredientId: ingredientId,
    );
    final result = await _addItemUsecase.call(params);
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ShoppingListStatus.error,
          errorMessage: failure.errorMessage,
        );
        return false;
      },
      (newItem) {
        final updatedItems = [newItem, ...state.items];
        state = state.copyWith(
          status: ShoppingListStatus.loaded,
          items: updatedItems,
        );
        return true;
      },
    );
  }

  Future<void> toggleChecked(ShoppingListEntity item) async {
    // Optimistic update
    final updatedItems = state.items.map((e) {
      if (e.itemId == item.itemId) {
        return ShoppingListEntity(
          itemId: e.itemId,
          userId: e.userId,
          quantity: e.quantity,
          unit: e.unit,
          category: e.category,
          isChecked: !e.isChecked,
          ingredientId: e.ingredientId,
          createdAt: e.createdAt,
          updatedAt: e.updatedAt,
        );
      }
      return e;
    }).toList();
    state = state.copyWith(items: updatedItems);

    final toggledItem = ShoppingListEntity(
      itemId: item.itemId,
      userId: item.userId,
      quantity: item.quantity,
      unit: item.unit,
      category: item.category,
      isChecked: !item.isChecked,
      ingredientId: item.ingredientId,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );

    final result = await _updateItemUsecase.call(toggledItem);
    result.fold(
      (failure) {
        // Revert on failure
        state = state.copyWith(
          items: state.items.map((e) {
            if (e.itemId == item.itemId) return item;
            return e;
          }).toList(),
          errorMessage: failure.errorMessage,
        );
      },
      (_) {
        // Already updated optimistically
      },
    );
  }

  Future<void> deleteItem(String itemId) async {
    // Optimistically remove the item immediately to avoid Dismissible error
    final previousItems = state.items;
    final updatedItems = state.items.where((e) => e.itemId != itemId).toList();
    state = state.copyWith(
      status: ShoppingListStatus.loaded,
      items: updatedItems,
    );

    final result = await _deleteItemUsecase.call(itemId);
    result.fold(
      (failure) {
        // Revert on failure
        state = state.copyWith(
          status: ShoppingListStatus.error,
          items: previousItems,
          errorMessage: failure.errorMessage,
        );
      },
      (_) {
        // Already removed optimistically
      },
    );
  }
}
