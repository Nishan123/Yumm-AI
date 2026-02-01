import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class RecipeTitleWidget extends StatelessWidget {
  final String recipeName;
  final VoidCallback onTap;
  final bool isTitleExpanded;
  const RecipeTitleWidget({
    super.key,
    required this.recipeName,
    required this.onTap,
    required this.isTitleExpanded
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedCrossFade(
          firstChild: Text(
            textAlign: TextAlign.left,
            recipeName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h2.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          secondChild: Text(
            textAlign: TextAlign.left,
            recipeName,
            style: AppTextStyles.h2.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          crossFadeState: isTitleExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
