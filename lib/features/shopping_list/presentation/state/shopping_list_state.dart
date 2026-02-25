import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';

enum ShoppingListStatus {
  initial,
  loading,
  loaded,
  adding,
  updating,
  deleting,
  error,
}

class ShoppingListState extends Equatable {
  final ShoppingListStatus status;
  final List<ShoppingListEntity> items;
  final String? errorMessage;

  const ShoppingListState({
    this.status = ShoppingListStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  ShoppingListState copyWith({
    ShoppingListStatus? status,
    List<ShoppingListEntity>? items,
    String? errorMessage,
  }) {
    return ShoppingListState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
