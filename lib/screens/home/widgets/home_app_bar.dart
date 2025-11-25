import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/widgets/custom_icon_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        spacing: 6,
        children: [
          CircleAvatar(radius: 23, backgroundColor: AppColors.blackColor),
          Column(
            spacing: 2.6,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi👋,", style: AppTextStyles.h5),
              Text(
                "Username",
                style: AppTextStyles.normalText.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [CustomIconButton(onTap: () {}, icon: Icons.menu),SizedBox(width: 18,)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
