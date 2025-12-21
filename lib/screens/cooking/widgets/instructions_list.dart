import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/screens/cooking/widgets/instruction_list_tile.dart';

class InstructionsList extends StatelessWidget {
  const InstructionsList({
    super.key,
    this.scrollController,
    this.isActive = true,
  });

  final ScrollController? scrollController;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    Color _colorForIndex(int index) {
      final rnd = Random(index * 9973);
      final r = rnd.nextInt(256);
      final g = rnd.nextInt(256);
      final b = rnd.nextInt(256);
      return Color.fromARGB(100, r, g, b);
    }

    Color _stepTextColor(int index) {
      final rnd = Random(index * 9973);
      final r = rnd.nextInt(256);
      final g = rnd.nextInt(256);
      final b = rnd.nextInt(256);
      return Color.fromARGB(500, r, g, b);
    }

    return ListView.builder(
      controller: isActive ? scrollController : null,
      physics: isActive
          ? BouncingScrollPhysics()
          : NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: 8,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Follow all the steps ⭐",
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
        return InstructionListTile(
          stepColor: _stepTextColor(index),
          borderColor: _colorForIndex(index),
          instruction:
              'Detailed instruction to prepare the dish with some extra tips.',
          stepCount: index,
        );
      },
    );
  }
}
