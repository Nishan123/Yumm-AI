import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class SettingItemCard extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subTitle;
  const SettingItemCard({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () {},
      leading: Icon(leadingIcon, size: 30),
      title: Text(
        title,
        style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subTitle,
        style: AppTextStyles.normalText.copyWith(
          color: AppColors.descriptionTextColor,
        ),
      ),
    );
  }
}
