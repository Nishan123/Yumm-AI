import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class CookbookLoadingSkelaton extends StatelessWidget {
  const CookbookLoadingSkelaton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _loadingSkelaton(context);
      },
    );
  }
}

Widget _loadingSkelaton(BuildContext context) {
  final mq = MediaQuery.of(context).size;
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(left: 18, right: 18, bottom: 24),
    width: mq.width,
    decoration: BoxDecoration(
      color: AppColors.extraLightBlackColor,
      borderRadius: BorderRadius.circular(30),
 
    ),
    child: Shimmer.fromColors(
      baseColor: AppColors.whiteColor,
      highlightColor: AppColors.extraLightBlackColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container Skelaton
              Container(
                width: mq.width * 0.27,
                height: mq.width * 0.27,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor, 
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(width: 12),
              // Information Column Skelaton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 18,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor, 
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 18,
                      width: mq.width * 0.35,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 12,
                      width: mq.width * 0.4,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Info chips
                    Row(
                      children: [
                        Container(
                          height: 24,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          height: 24,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
      
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Button skelaton
          Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ],
      ),
    ),
  );
}
