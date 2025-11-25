import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class CustomButtomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomButtomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 20)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 208, 208, 208),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(width: 4, color: AppColors.whiteColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildNavItem(
                  icon: LucideIcons.house,
                  index: 0,
                  isSelected: currentIndex == 0,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: LucideIcons.package,
                  index: 1,
                  isSelected: currentIndex == 1,
                ),
              ),
              SizedBox(width: 70),

              Expanded(
                child: _buildNavItem(
                  icon: LucideIcons.book_open,
                  index: 2,
                  isSelected: currentIndex == 2,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: LucideIcons.circle_user,
                  index: 3,
                  isSelected: currentIndex == 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.shadowColor : null,
          // gradient: isSelected
          //     ? LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //         colors: [
          //           AppColors.primaryColor,
          //           AppColors.primaryColor,
          //           AppColors.whiteShadowColor,
          //         ],
          //       )
          //     : null,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? AppColors.whiteColor
                  : AppColors.normalIconColor,
            ),
          ],
        ),
      ),
    );
  }
}
