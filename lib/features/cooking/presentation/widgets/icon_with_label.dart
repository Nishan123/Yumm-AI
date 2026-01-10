import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class IconWithLabel extends StatelessWidget {
  final Color iconColor;
  final IconData icon;
  final String text;
  const IconWithLabel({super.key, required this.iconColor, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [Icon(icon, size: 32,color: iconColor,), Text(text,style: AppTextStyles.normalText.copyWith(fontWeight: FontWeight.w600),)],
    );
  }
}
