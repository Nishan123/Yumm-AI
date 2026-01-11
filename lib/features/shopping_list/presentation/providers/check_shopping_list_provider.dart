import 'package:flutter_riverpod/legacy.dart';

final checkShoppingListProvider = StateProvider.family<bool, int>((ref, id) {
  return false;
});
