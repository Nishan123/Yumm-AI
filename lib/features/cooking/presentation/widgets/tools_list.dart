import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/tools_list_tile.dart';

class ToolsList extends StatelessWidget {
  final bool isActive;
  final ScrollController? scrollController;

  const ToolsList({super.key, required this.isActive, this.scrollController});

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
      primary: false,
      shrinkWrap: true,
      physics: isActive
          ? BouncingScrollPhysics()
          : NeverScrollableScrollPhysics(),
      controller: isActive ? scrollController : null,
      itemCount: 20,
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
        return ToolsListTile(
          toolName: "Microwave",
          image:
              "https://assets.stickpng.com/images/5b51f104c051e602a568ce69.png",
          textColor: colorForIndex(index),
        );
      },
    );
  }
}
