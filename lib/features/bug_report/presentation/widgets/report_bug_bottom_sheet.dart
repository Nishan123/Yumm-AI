import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:lottie/lottie.dart';

class ReportBugBottomSheet extends StatelessWidget {
  final Uint8List? screenshot;
  const ReportBugBottomSheet({super.key, this.screenshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height * 0.39,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Lottie.asset(
            "${ConstantsString.assetLottie}/phone_shake.json",
            frameRate: FrameRate(60),
            height: 120,
          ),
          Text(
            "Report technical problems!",
            style: AppTextStyles.title.copyWith(color: AppColors.redColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              "We've detected a shake on your device. Would you like to report a technical issue? This will capture a screenshot to help us resolve the problem faster.",
              textAlign: TextAlign.center,
              style: AppTextStyles.descriptionText.copyWith(
                color: AppColors.descriptionTextColor,
              ),
            ),
          ),
          Spacer(),
          SecondaryButton(
            onTap: () {
              context.pushNamed("report_bug", extra: screenshot);
            },
            borderRadius: 40,
            margin: EdgeInsets.all(0),
            backgroundColor: AppColors.redColor,
            text: "Report Bug",
          ),
        ],
      ),
    );
  }
}
