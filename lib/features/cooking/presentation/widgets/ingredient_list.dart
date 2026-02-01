import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/ingredient_entity.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/ingredients_list_tile.dart';

class IngredientList extends StatelessWidget {
  final bool isActive;
  final List<IngredientEntity> ingredients;
  final Function(int index, bool value) onToggle;
  const IngredientList({
    super.key,
    required this.isActive,
    required this.ingredients,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor(int index) {
      final rnd = Random(index * 9973);
      final r = rnd.nextInt(256);
      final g = rnd.nextInt(256);
      final b = rnd.nextInt(256);
      return Color.fromARGB(500, r, g, b);
    }

    return ListView.builder(
      itemCount: ingredients.length + 1,
      padding: EdgeInsets.zero,
      physics: isActive
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),

      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "All the ingredients you'll need 🍎",
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
          );
        }
        final ingredient = ingredients[index - 1];
        return IngredientsListTile(
          ingredient: IngredientModel.fromEntity(ingredient),
          textColor: textColor(index),
          onChecked: (value) => onToggle(index - 1, value ?? false),
        );
      },
    );
  }
}
