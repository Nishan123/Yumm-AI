import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/screens/setting/widgets/setting_item_card.dart';

class SettingListGroup extends StatelessWidget {
  final String groupName;
  final List<SettingItemCard> settingLists;
  const SettingListGroup({
    super.key,
    required this.settingLists,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          groupName,
          style: AppTextStyles.h5.copyWith(
            color: AppColors.descriptionTextColor,
            fontWeight: FontWeight.w400
          ),
        ),
        ...settingLists,
      ],
    );
  }
}
