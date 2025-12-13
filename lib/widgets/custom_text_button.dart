import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? textColor;
  final TextStyle? buttonTextStyle;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
    this.buttonTextStyle
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: buttonTextStyle?? AppTextStyles.h5.copyWith(
          color: textColor ?? AppColors.blueColor,
        ),
      ),
    );
  }
}
