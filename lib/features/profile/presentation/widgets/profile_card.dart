import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/widgets/primary_button.dart';
import 'package:yumm_ai/features/profile/presentation/widgets/change_username_text_filed.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return // Profile Container
    Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      width: mq.size.width,
      decoration: BoxDecoration(
        border: ContainerProperty.mainBorder,
        borderRadius: BorderRadius.circular(36),
        color: AppColors.extraLightBlackColor,
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              CircleAvatar(radius: 30, backgroundColor: AppColors.primaryColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Text(
                        "Username",
                        style: AppTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                        ),
                      ),
                      _planChip(
                        backgroundColor: AppColors.lightBlueColor,
                        plan: "Free",
                      ),
                    ],
                  ),
                  Text(
                    "user@example.com",
                    style: AppTextStyles.h6.copyWith(
                      color: AppColors.descriptionTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ChangeUsernameTextFiled(),
          SizedBox(height: 20,),
          PrimaryButton(text: "Upgrade to Pro", onTap: (){})
        ],
      ),
    );
  }

  Widget _planChip({required Color backgroundColor, required String plan}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        plan,
        style: AppTextStyles.normalText.copyWith(color: AppColors.whiteColor),
      ),
    );
  }
}
