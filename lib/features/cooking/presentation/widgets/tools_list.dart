import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_kitchen_tool_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_kitchen_tool_entity.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/tools_list_tile.dart';

class ToolsList extends StatelessWidget {
  final bool isActive;
  final List<RecipeKitchenToolEntity> kitchenTool;
  final Function(int index, bool value) onToggle;

  const ToolsList({
    super.key,
    required this.isActive,
    required this.kitchenTool,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    Color colorForIndex(int index) {
      final rnd = Random(index * 9973);
      final r = rnd.nextInt(256);
      final g = rnd.nextInt(256);
      final b = rnd.nextInt(256);
      return Color.fromARGB(500, r, g, b);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: isActive
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: kitchenTool.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "All the tools you'll need 🔪",
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
          );
        }
        final kitchenTools = kitchenTool[index - 1];
        return ToolsListTile(
          onChecked: (value) => onToggle(index - 1, value ?? false),
          kitchenTool: RecipeKitchenToolModel.fromEntity(kitchenTools),
          textColor: colorForIndex(index),
        );
      },
    );
  }
}
