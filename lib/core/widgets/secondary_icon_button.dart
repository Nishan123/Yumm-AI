import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class SecondaryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  const SecondaryIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Icon(icon,color: iconColor??AppColors.blackColor,),
    );
  }
}
