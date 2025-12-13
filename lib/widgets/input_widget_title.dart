import 'package:flutter/material.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/widgets/custom_text_button.dart';

class InputWidgetTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onActionTap;
  final String? actionButtonText;
  final bool? haveActionButton;
  final EdgeInsets? padding;

  const InputWidgetTitle({
    super.key,
    required this.title,
    this.onActionTap,
    this.actionButtonText,
    this.haveActionButton,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? Constants.commonPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h5),
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
