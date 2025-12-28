import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';

class SecondaryButton extends StatelessWidget {
  final Color backgroundColor;
  final double? borderRadius;
  final VoidCallback onTap;
  final String text;
  final bool? haveHatIcon;
  final EdgeInsets? margin;
  const SecondaryButton({
    super.key,
    required this.backgroundColor,
    this.borderRadius,
    required this.onTap,
    required this.text,
    this.haveHatIcon,
    this.margin
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin??ConstantsString.commonPadding,
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.whiteColor,
        ),
        onPressed: onTap,
        child: (haveHatIcon??false)?Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          SizedBox(width: 14,),
          Text(text),
          SvgPicture.asset("${ConstantsString.assetSvg}/hatIcon.svg")
        ],):Text(text)
      ),
    );
  }
}
