import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onFilterTap;
  const HomeSearchBar({super.key, required this.onTap, required this.onFilterTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Hero(
        tag: 'homeSearchBarHero',
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppColors.lightBlackColor),
              color: AppColors.lightBlackColor,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 15),
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: SvgPicture.asset(
                      "${ConstantsString.assetSvg}/pizza_icon.svg",
                    ),
                  ),
                ),

                // Search Text
                Expanded(
                  child: Text(
                    'What do you want to eat?',
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                ),

                // Settings Icon
                InkWell(
                  onTap: onFilterTap,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
