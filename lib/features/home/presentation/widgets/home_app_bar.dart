import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/primary_icon_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String profilePic;
  const HomeAppBar({
    super.key,
    required this.userName,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        spacing: 6,
        children: [
          Container(
            padding: EdgeInsets.all(1),

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightBlackColor
            ),
            child: CircleAvatar(
              radius: 23,
              backgroundColor: AppColors.lightBlackColor,
              backgroundImage: profilePic.isNotEmpty
                  ? NetworkImage(profilePic)
                  : null,
              child: profilePic.isEmpty
                  ? Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    )
                  : null,
            ),
          ),
          Column(
            spacing: 2.6,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Hi,", style: AppTextStyles.h5),
                  SvgPicture.asset(
                    "${ConstantsString.assetSvg}/ai_star.svg",
                    height: 20,
                  ),
                ],
              ),
              Text(
                userName,
                style: AppTextStyles.normalText.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        PrimaryIconButton(onTap: () {}, icon: Icons.menu),
        SizedBox(width: 18),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
