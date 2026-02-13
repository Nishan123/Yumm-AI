import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';

class SearchHeader extends StatelessWidget {
  final VoidCallback onBack;
  final TextEditingController controller;
  final VoidCallback onClear;
  final Function(String)? onSubmitted;
  final VoidCallback? onFilterTap;

  const SearchHeader({
    super.key,
    required this.onBack,
    required this.controller,
    required this.onClear,
    this.onSubmitted,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 18, top: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Hero(
              tag: 'homeSearchBarHero',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.lightBlackColor,
                    ),
                    color: AppColors.lightBlackColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 12),
                        child: SizedBox(
                          height: 26,
                          width: 26,
                          child: SvgPicture.asset(
                            "${ConstantsString.assetSvg}/pizza_icon.svg",
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          autofocus: true,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onSubmitted: onSubmitted,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: controller.text.isEmpty
                              ? InkWell(
                                  onTap: onFilterTap,
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    key: const ValueKey('filter'),
                                    width: 45,
                                    height: 45,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.tune,
                                      color: AppColors.blackColor,
                                      size: 28,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  key: const ValueKey('clear'),
                                  onTap: onClear,
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: AppColors.blackColor,
                                      size: 28,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
