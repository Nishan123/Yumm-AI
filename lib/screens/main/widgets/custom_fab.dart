import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class CustomFab extends StatelessWidget {
  final VoidCallback onTap;
  const CustomFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: InkWell(
        splashColor: AppColors.primaryColor,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.whiteShadowColor,
                AppColors.primaryColor,
                AppColors.primaryColor,
              ],
            ),
          ),
          padding: EdgeInsets.all(16),
          child: SvgPicture.asset(
            "${Constants.assetSvg}/scanner_icon.svg",
            height: 32,
            width: 32,
          ),
        ),
      ),
    );
  }
}
