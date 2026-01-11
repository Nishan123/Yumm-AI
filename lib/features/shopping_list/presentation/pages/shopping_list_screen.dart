import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';
import 'package:yumm_ai/features/shopping_list/presentation/providers/check_shopping_list_provider.dart';
import 'package:yumm_ai/features/shopping_list/presentation/widgets/shopping_list_tile.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List"),
        actions: [
          CustomTextButton(
            text: "Add Item",
            onTap: () {
              context.pushNamed("add_shopping_list");
            },
            buttonTextStyle: AppTextStyles.h6.copyWith(
              color: AppColors.blueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            final isChecked = ref.watch(checkShoppingListProvider(index));

            return ShoppingListTile(
              itemName: 'Item Name',
              dayAdded: '4',
              quantity: '20',
              isChecked: isChecked,
              onChanged: (value) {
                ref.read(checkShoppingListProvider(index).notifier).state =
                    value!;
              },
              itemImage:
                  'https://www.themealdb.com/images/ingredients/Butter.png',
            );
          },
        ),
      ),
    );
  }
}
