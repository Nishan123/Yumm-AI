import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final double? borderRadius;
  final VoidCallback onTap;

  const PrimaryButton({super.key, required this.text, this.borderRadius, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 40),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor,
            AppColors.extraLightBlackColor,
          ],
        ),
      ),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.whiteColor,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(text),
      ),
    );
  }
}
