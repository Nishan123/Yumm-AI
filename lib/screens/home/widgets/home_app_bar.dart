import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

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
      actions: [
        Container(
          margin: EdgeInsets.only(right: 18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lightBlackColor,
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu, color: AppColors.blackColor),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
