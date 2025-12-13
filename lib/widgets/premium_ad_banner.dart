import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/core/styles/container_property.dart';

class PremiumAdBanner extends StatelessWidget {
  final String text;
  final String backgroundImage;
  final VoidCallback onTap;
  final String buttonText;
  const PremiumAdBanner({
    super.key,
    required this.text,
    required this.backgroundImage,
    required this.onTap,
    required this.buttonText,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border:ContainerProperty.mainBorder,
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(25),
            child: SvgPicture.asset(backgroundImage, fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    wordSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.blackColor,
                    foregroundColor: AppColors.whiteColor,
                  ),
                  onPressed: onTap,
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
