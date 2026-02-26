import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/pantry_inventory/presentation/providers/pantry_inventory_provider.dart';
import 'package:yumm_ai/features/pantry_inventory/presentation/widgets/inventory_list_tile.dart';

class PantryInventoryScreen extends ConsumerWidget {
  const PantryInventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pantryAsync = ref.watch(pantryInventoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Pantry Inventory")),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pantryInventoryProvider);
          },
          child: pantryAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    "No items in your pantry.\nMark items in your Shopping List to add them here.",
                    style: AppTextStyles.normalText.copyWith(
                      color: AppColors.descriptionTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InventoryListTile(
                    itemName: item.name,
                    imageUrl: item.imageUrl,
                    quantity: item.quantity,
                    unit: item.unit,
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text(
                "Failed to load pantry: $error",
                style: AppTextStyles.normalText.copyWith(
                  color: AppColors.redColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
