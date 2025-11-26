import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? textColor;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(text, style: AppTextStyles.h5.copyWith(color: textColor)),
    );
  }
}
