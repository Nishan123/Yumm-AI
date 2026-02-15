import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

class SearchResultCards extends StatelessWidget {
  final RecipeEntity recipe;

  const SearchResultCards({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed("cooking", extra: recipe);
      },
      child: Container(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 30),
        width: double.infinity,
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightBlackColor,
                borderRadius: BorderRadius.circular(26),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.27,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: recipe.images.isNotEmpty
                          ? Image.network(
                              recipe.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/images/salad.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              "assets/images/salad.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12, top: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(60),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white12,
                              backgroundBlendMode: BlendMode.colorBurn,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8,
                              children: [
                                Icon(LucideIcons.heart,color: AppColors.whiteColor,size: 18,),
                                Text(
                                  recipe.likes.length.toString(),
                                  style: AppTextStyles.h5.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.whiteColor
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Text(
              recipe.recipeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.h5,
            ),
            Text(
              recipe.description,
              style: AppTextStyles.descriptionText.copyWith(
                color: AppColors.descriptionTextColor,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
