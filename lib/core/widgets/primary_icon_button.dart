import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class PrimaryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  const PrimaryIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(120),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? AppColors.lightBlackColor,
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: iconColor ?? AppColors.blackColor),
          ),
        ),
      ),
    );
  }
}
