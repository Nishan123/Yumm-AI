import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';

class InputWidgetTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onActionTap;
  final String? actionButtonText;
  final bool? haveActionButton;
  final EdgeInsets? padding;
  final String? dataText;

  const InputWidgetTitle({
    super.key,
    required this.title,
    this.onActionTap,
    this.actionButtonText,
    this.haveActionButton,
    this.padding,
    this.dataText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? ConstantsString.commonPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 6,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.h5),
              Text(
                dataText??"",
                style: AppTextStyles.h5.copyWith(color: AppColors.primaryColor),
              ),
            ],
          ),
          haveActionButton ?? false
              ? CustomTextButton(
                  buttonTextStyle: AppTextStyles.normalText.copyWith(
                    color: AppColors.blueColor,
                  ),
                  text: actionButtonText ?? actionButtonText ?? "",
                  onTap: onActionTap ?? () {},
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
