import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class CookbookHint extends StatelessWidget {
  final String text;
  const CookbookHint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(color: AppColors.lightPrimaryColor),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Text(
            text,
            style: TextStyle(color: AppColors.whiteColor),
          ),
          Icon(LucideIcons.chef_hat, size: 18, color: AppColors.whiteColor),
        ],
      ),
    );
  }
}
