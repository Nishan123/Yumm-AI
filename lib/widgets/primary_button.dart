import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.whiteColor,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent, // Remove shadow
        ),
        child: Text(text),
      ),
    );
  }
}
