import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class CachedImageErrorWidget extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  const CachedImageErrorWidget({
    super.key,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor.withOpacity(0.1),
      ),
      child: Center(child: Icon(icon, color: AppColors.primaryColor, size: 20)),
    );
  }
}
