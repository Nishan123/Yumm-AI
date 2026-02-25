import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class RecommendedFoodSnapLoadingSkelaton extends StatelessWidget {
  const RecommendedFoodSnapLoadingSkelaton({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    // Match the PageController viewportFraction (0.90) for card width
    final cardWidth = mq.width * 0.82;

    return SizedBox(
      width: mq.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            // Focused card (left)
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 12),
              child: SizedBox(
                width: cardWidth,
                child: Stack(
                  children: [
                    // Shimmering Background
                    Shimmer.fromColors(
                      baseColor: AppColors.skeletonBaseColor,
                      highlightColor: AppColors.skeletonHighlightColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: AppColors.skeletonBaseColor,
                        ),
                      ),
                    ),
                    // Heart button placeholder (top right)
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    // Bottom content placeholders
                    Positioned(
                      bottom: 20,
                      left: 12,
                      right: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title placeholder
                          Container(
                            height: 20,
                            width: cardWidth * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Info boxes placeholder row
                          Row(
                            children: [
                              Container(
                                height: 36,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                height: 36,
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Unfocused card (right, peeking)
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 12),
              child: SizedBox(
                width: cardWidth,
                child: Stack(
                  children: [
                    // Shimmering Background
                    Shimmer.fromColors(
                      baseColor: AppColors.skeletonBaseColor,
                      highlightColor: AppColors.skeletonHighlightColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: AppColors.skeletonBaseColor,
                        ),
                      ),
                    ),
                    // Heart button placeholder (top right)
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    // Bottom content placeholders
                    Positioned(
                      bottom: 20,
                      left: 12,
                      right: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title placeholder
                          Container(
                            height: 18,
                            width: cardWidth * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Info boxes placeholder row
                          Row(
                            children: [
                              Container(
                                height: 32,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: 32,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
