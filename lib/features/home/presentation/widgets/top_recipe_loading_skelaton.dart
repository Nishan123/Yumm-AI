import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class TopRecipeLoadingSkelaton extends StatelessWidget {
  const TopRecipeLoadingSkelaton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightBlackColor,
      highlightColor: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _topRecipeLoadingCard(context);
          },
        ),
      ),
    );
  }
}

Widget _topRecipeLoadingCard(BuildContext context) {
  final mq = MediaQuery.of(context).size;
  return Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.27,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: AppColors.extraLightBlackColor,
          ),

        ),
        Container(
          height: mq.height * 0.03,
          width: mq.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.extraLightBlackColor,
          ),
        ),
        Container(
          height: mq.height * 0.05,
          width: mq.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.extraLightBlackColor,
          ),
        ),
        Row(
          spacing: 4,
          children: [
            Container(
              height: mq.height * 0.016,
              width: mq.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.extraLightBlackColor,
              ),
            ),
            Container(
              height: mq.height * 0.016,
              width: mq.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.extraLightBlackColor,
              ),
            ),
            Container(
              height: mq.height * 0.016,
              width: mq.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.extraLightBlackColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
