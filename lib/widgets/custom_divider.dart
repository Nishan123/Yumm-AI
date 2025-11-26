import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider()),
        Text("  OR  ", style: AppTextStyles.normalText),
        Expanded(child: Divider()),
      ],
    );
  }
}
