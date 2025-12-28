import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';

class ChefCardWidget extends StatelessWidget {
  final String suffixImage;
  final String backgroundImage;
  final VoidCallback onTap;
  final String title;
  final String description;
  final bool isLocked;
  final bool isSuffixCropped;
  const ChefCardWidget({
    super.key,
    required this.suffixImage,
    required this.backgroundImage,
    required this.onTap,
    required this.title,
    required this.description,
    required this.isLocked,
    this.isSuffixCropped = false,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: ConstantsString.commonPadding,
        height: mq.height * 0.16,
        decoration: BoxDecoration(
          color: AppColors.extraLightBlackColor,
          borderRadius: BorderRadius.circular(24),
          border: ContainerProperty.mainBorder,
          boxShadow: [ContainerProperty.mainShadow],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.2),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: backgroundImage,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 8,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(title, style: AppTextStyles.h5),
                              isLocked
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: AppColors.redColor,
                                      ),
                                      child: Icon(
                                        LucideIcons.lock,
                                        size: 18,
                                        color: AppColors.whiteColor,
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: mq.width * 0.6,
                            child: Text(
                              softWrap: true,
                              description,
                              style: AppTextStyles.descriptionText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8,
                      right: 8,
                      left: 8,
                      bottom: isSuffixCropped ? 0 : 8,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: suffixImage,
                      width: 110,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
