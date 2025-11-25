import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
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
              child: SvgPicture.asset("assets/images/pizza_icon.svg"),
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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.tune, color: AppColors.blackColor, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
