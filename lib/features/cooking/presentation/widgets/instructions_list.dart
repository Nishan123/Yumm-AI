import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/data/models/instruction_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/instruction_entity.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/instruction_list_tile.dart';

class InstructionsList extends StatelessWidget {
  const InstructionsList({
    super.key,
    this.scrollController,
    this.isActive = true,
    required this.instruction,
    required this.onToggle,
  });

  final ScrollController? scrollController;
  final bool isActive;
  final List<InstructionEntity> instruction;
  final Function(int index, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    Color colorForIndex(int index) {
      final rnd = Random(index * 9973);
      final r = rnd.nextInt(256);
      final g = rnd.nextInt(256);
      final b = rnd.nextInt(256);
      return Color.fromARGB(100, r, g, b);
    }

    Color stepTextColor(int index) {
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
      itemCount: instruction.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 12),
            child: Text(
              "Follow all the steps ⭐",
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
          );
        }
        final instructions = instruction[index - 1];

        return InstructionListTile(
          index: index,
          stepColor: stepTextColor(index),
          borderColor: colorForIndex(index),
          instruction: InstructionModel.fromEntity(instructions),
          stepCount: index,
          isLast: index == instruction.length - 1,
          onChecked: (value) => onToggle(index - 1, value ?? false),
        );
      },
    );
  }
}
