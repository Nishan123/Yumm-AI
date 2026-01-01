import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class DealsCard extends StatelessWidget {
  final bool isSelected;
  final bool haveBestValueTag;
  final double actualPrice;
  final double oldPrice;
  final String duration;
  final bool? haveOldPrice;
  final VoidCallback onTap;

  const DealsCard({
    super.key,
    required this.mq,
    required this.isSelected,
    required this.haveBestValueTag,
    required this.actualPrice,
    required this.oldPrice,
    required this.duration,
    this.haveOldPrice,
    required this.onTap,
  });

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        width: mq.width * 0.87,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: BorderDirectional(
            top: BorderSide(width: 1.8, color: AppColors.blackColor),
            start: BorderSide(width: 1.8, color: AppColors.blackColor),
            end: BorderSide(width: 6, color: AppColors.blackColor),
            bottom: BorderSide(width: 6, color: AppColors.blackColor),
          ),
          color: isSelected
              ? AppColors.extraLightBlackColor
              : AppColors.whiteColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w800,
                    ),
                    children: [
                      haveOldPrice ?? true
                          ? TextSpan(
                              text: "$oldPrice ",
                              style: TextStyle(
                                color: AppColors.normalIconColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            )
                          : TextSpan(),
                      TextSpan(
                        text: "$actualPrice ",
                        style: TextStyle(color: AppColors.grayColor),
                      ),
                      TextSpan(
                        text: "USD / ",
                        style: TextStyle(color: AppColors.grayColor),
                      ),
                      TextSpan(text: duration, style: AppTextStyles.normalText),
                    ],
                  ),
                ),
                Spacer(),
                haveBestValueTag
                    ? Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightBlackColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          "BEST VALUE",
                          style: AppTextStyles.normalText.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 6),
            _benefitsText("Unlimited Generated Recipes"),
            _benefitsText("Access to all Pro Chef Modes"),
            _benefitsText("Daily Meal Plan Tracking"),
            _benefitsText("Unlimited Cookbook & Shopping\nLists"),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _benefitsText(String text) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 2),
      child: Row(
        spacing: 6,
        children: [
          Icon(Icons.check_circle, color: AppColors.primaryColor),
          Text(
            text,
            style: AppTextStyles.descriptionText.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
