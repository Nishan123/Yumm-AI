import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/data/models/instruction_model.dart';

class InstructionListTile extends StatelessWidget {
  final Color borderColor;
  final InstructionModel instruction;
  final int stepCount;
  final Color stepColor;
  final int index;
  final bool isLast;
  final Function(bool?)? onChecked;
  const InstructionListTile({
    super.key,
    required this.borderColor,
    required this.instruction,
    required this.stepCount,
    required this.stepColor,
    required this.index,
    this.isLast = false,
    this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: instruction.isDone
                        ? null
                        : Border.all(width: 1.5, color: AppColors.primaryColor),
                    color: instruction.isDone
                        ? AppColors.primaryColor
                        : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                    child: instruction.isDone
                        ? Icon(
                            Icons.check,
                            key: ValueKey('icon'),
                            color: AppColors.whiteColor,
                            size: 18,
                          )
                        : Text(
                            index.toString(),
                            key: ValueKey('text'),
                            style: AppTextStyles.h6.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5, // Slightly thinner line for subtlety
                      color: AppColors.primaryColor.withOpacity(
                        0.5,
                      ), // More subtle color
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 0, right: 16, top: 0, bottom: 12),
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.6, color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: AppTextStyles.descriptionText.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.descriptionTextColor,
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
                        Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: instruction.isDone,
                          onChanged: onChecked,
                        ),
                      ],
                    ),
                    Divider(thickness: 0.6),
                    Text(
                      instruction.instruction,
                      style: instruction.isDone
                          ? TextStyle(
                              fontSize: 14,
                              color: AppColors.descriptionTextColor,
                              decoration: TextDecoration.lineThrough,
                            )
                          : AppTextStyles.normalText,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
