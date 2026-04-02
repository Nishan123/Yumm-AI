import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class HomeAppBarLoadingSkelaton extends StatelessWidget {
  const HomeAppBarLoadingSkelaton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Shimmer.fromColors(
        baseColor: AppColors.extraLightBlackColor,
        highlightColor: AppColors.whiteColor,
        child: Row(
          spacing: 10,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.extraLightBlackColor,
              ),
            ),
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.extraLightBlackColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 10,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.extraLightBlackColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.extraLightBlackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
