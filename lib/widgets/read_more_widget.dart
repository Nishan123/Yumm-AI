import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

class ReadMoreWidget extends StatelessWidget {
  final int? trimLine;
  final String text;
  const ReadMoreWidget({super.key, required this.text, this.trimLine});

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      style: AppTextStyles.normalText.copyWith(
        color: AppColors.descriptionTextColor,
      ),
      trimLines: trimLine??2,
      trimMode: TrimMode.Line,
      trimCollapsedText: "More",
      trimExpandedText: "Read Less",
      moreStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.blueColor,
      ),
      lessStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.blueColor,
      ),
    );
  }
}
