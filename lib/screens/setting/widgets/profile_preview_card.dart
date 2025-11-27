import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

class ProfilePreviewCard extends StatelessWidget {
  const ProfilePreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.extraLightBlackColor
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
    );
  }
}
