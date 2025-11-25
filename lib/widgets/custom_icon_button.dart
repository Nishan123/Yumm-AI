import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const CustomIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightBlackColor,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.blackColor),
      ),
    );
  }
}
