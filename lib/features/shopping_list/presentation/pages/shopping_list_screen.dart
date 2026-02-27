import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/cookbook_hint.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/features/shopping_list/data/services/ingredient_lookup_service.dart';
import 'package:yumm_ai/features/shopping_list/presentation/enums/shopping_list_type.dart';
import 'package:yumm_ai/features/shopping_list/presentation/state/shopping_list_state.dart';
import 'package:yumm_ai/features/shopping_list/presentation/view_model/shopping_list_view_model.dart';
import 'package:yumm_ai/features/shopping_list/presentation/widgets/shopping_list_tile.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  ShoppingListType _itemType = ShoppingListType.any;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShoppingList();
    });
  }

  Future<void> _loadShoppingList({bool forceRefresh = false}) async {
    final currentState = ref.read(shoppingListViewModelProvider);
    if (!forceRefresh &&
        currentState.items.isNotEmpty &&
        currentState.status != ShoppingListStatus.initial &&
        currentState.status != ShoppingListStatus.error) {
      return; // Use cached data
    }

    final category = _itemType == ShoppingListType.any ? null : _itemType.value;
    ref
        .read(shoppingListViewModelProvider.notifier)
        .getItems(category: category);
  }

  void _onCategoryChanged(ShoppingListType type) {
    setState(() {
      _itemType = type;
    });
    final category = type == ShoppingListType.any ? null : type.value;
    ref
        .read(shoppingListViewModelProvider.notifier)
        .getItems(category: category);
  }

  String _formatDaysAgo(DateTime? date) {
    if (date == null) return '0';
    final diff = DateTime.now().difference(date).inDays;
    return diff.toString();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListState = ref.watch(shoppingListViewModelProvider);
    final ingredientLookup = ref.watch(ingredientLookupProvider);
    final lookupMap = ingredientLookup.value ?? {};

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ElevatedButton.icon(
          icon: Icon(LucideIcons.leafy_green),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.blackColor,
            foregroundColor: AppColors.whiteColor,
          ),
          onPressed: () async {
            final result = await context.pushNamed("add_shopping_list");
            if (result == true) {
              _loadShoppingList(forceRefresh: true);
            }
          },
          label: Text("Add Item"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(title: Text("Shopping List")),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadShoppingList(forceRefresh: true),
          child: Column(
            children: [
              SizedBox(height: 12),
              CustomChoiceChip(
                onSelected: (value) {
                  _onCategoryChanged(value);
                },
                values: ShoppingListType.values,
                labelBuilder: (item) => item.text,
                iconBuilder: (item) => null,
              ),
              SizedBox(height: 12),
              CookbookHint(text: "Marked items will be saved in inventory"),
              SizedBox(height: 12),
              Expanded(child: _buildBody(shoppingListState, lookupMap)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    ShoppingListState shoppingListState,
    Map<String, dynamic> lookupMap,
  ) {
    if (shoppingListState.status == ShoppingListStatus.loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (shoppingListState.status == ShoppingListStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              shoppingListState.errorMessage ?? 'Something went wrong',
              style: AppTextStyles.normalText.copyWith(
                color: AppColors.redColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                final category = _itemType == ShoppingListType.any
                    ? null
                    : _itemType.value;
                ref
                    .read(shoppingListViewModelProvider.notifier)
                    .getItems(category: category);
              },
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (shoppingListState.items.isEmpty &&
        shoppingListState.status == ShoppingListStatus.loaded) {
      return Center(
        child: Text(
          "No items in your shopping list.\nTap 'Add Item' to get started!",
          style: AppTextStyles.normalText.copyWith(
            color: AppColors.descriptionTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: shoppingListState.items.length,
      itemBuilder: (context, index) {
        final item = shoppingListState.items[index];
        return Dismissible(
          key: Key(item.itemId ?? index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 24),
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.redColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.delete, color: AppColors.whiteColor),
          ),
          onDismissed: (_) {
            if (item.itemId != null) {
              ref
                  .read(shoppingListViewModelProvider.notifier)
                  .deleteItem(item.itemId!);
            }
          },
          child: Builder(
            builder: (context) {
              // Resolve name and image from local JSON via ingredientId
              String displayName = 'Unknown Item';
              String displayImage = '';
              if (item.ingredientId != null &&
                  item.ingredientId!.isNotEmpty &&
                  lookupMap.containsKey(item.ingredientId)) {
                final ingredient = lookupMap[item.ingredientId];
                displayName = ingredient.name;
                displayImage = ingredient.imageUrl;
              }
              return ShoppingListTile(
                itemName: displayName.isEmpty ? 'Unknown Item' : displayName,
                dayAdded: _formatDaysAgo(item.createdAt),
                quantity: '${item.quantity} ${item.unit}',
                isChecked: item.isChecked,
                onChanged: (value) {
                  ref
                      .read(shoppingListViewModelProvider.notifier)
                      .toggleChecked(item);
                },
                itemImage: displayImage,
              );
            },
          ),
        );
      },
    );
  }
}
