import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

class InstructionListTile extends StatelessWidget {
  final Color borderColor;
  final String instruction;
  final int stepCount;
  final Color stepColor;
  const InstructionListTile({
    super.key,
    required this.borderColor,
    required this.instruction,
    required this.stepCount,
    required this.stepColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 0.6, color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: AppTextStyles.descriptionText.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.descriptionTextColor
              ),
              children: [
                TextSpan(text: "Step: "),
                TextSpan(
                  text: stepCount.toString(),
                  style: AppTextStyles.descriptionText.copyWith(
                    fontWeight: FontWeight.bold,
                    color: stepColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 0.6,),
          Text(instruction, style: AppTextStyles.normalText),
        ],
      ),
    );
  }
}
