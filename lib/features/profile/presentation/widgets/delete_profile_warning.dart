import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class DeleteProfileWarning extends StatelessWidget {
  const DeleteProfileWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.redColor.withAlpha(8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.redColor.withAlpha(40)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.redColor),
              const SizedBox(width: 8),
              Text(
                "Warning",
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.redColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Deleting your account is permanent and cannot be undone. All your data will be permanently erased. By proceeding, you will lose access to your account immediately.",
            style: AppTextStyles.descriptionText.copyWith(
              color: AppColors.redColor.withAlpha(200),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
