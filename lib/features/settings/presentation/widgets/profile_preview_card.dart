import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class ProfilePreviewCard extends StatelessWidget {
  final VoidCallback onTap;

  const ProfilePreviewCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.extraLightBlackColor,
          border: Border.all(width: 1, color: AppColors.lightBlackColor),
        ),
        child: Row(
          spacing: 8,
          children: [
            CircleAvatar(radius: 26, backgroundColor: AppColors.blackColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Username",
                  style: AppTextStyles.title.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "email@example.com",
                  style: AppTextStyles.normalText.copyWith(
                    color: AppColors.descriptionTextColor,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(LucideIcons.chevron_right, size: 30),
          ],
        ),
      ),
    );
  }
}
