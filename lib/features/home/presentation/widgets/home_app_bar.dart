import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/primary_icon_button.dart';

class HomeAppBar extends StatelessWidget {
  final String profilePic;
  final String userName;
  const HomeAppBar({
    super.key,
    required this.profilePic,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 6,
        children: [
          Container(
            padding: EdgeInsets.all(1),

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightBlackColor,
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                children: [
                  Text("Hi,", style: AppTextStyles.h5),
                  Image.asset(
                    "${ConstantsString.assetGif}/hi_user.gif",
                    height: 30,
                  ),
                ],
              ),
              Text(
                userName,
                style: AppTextStyles.normalText.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.descriptionTextColor,
                  height: 1,
                ),
              ),
            ],
          ),
          Spacer(),
          PrimaryIconButton(
          onTap: () {
            context.pushNamed("notifications");
          },
          icon: LucideIcons.bell,
        ),
        ],
      ),
    );
  }
}
