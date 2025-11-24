import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class CustomChoiceChip extends StatefulWidget {
  final void Function(String sport)? onFoodTypeSelected;
  final EdgeInsetsGeometry padding;
  const CustomChoiceChip({
    super.key,
    this.onFoodTypeSelected,
    this.padding = const EdgeInsets.only(right: 16),
  });

  @override
  State<CustomChoiceChip> createState() => _CustomChoiceChipState();
}

class _CustomChoiceChipState extends State<CustomChoiceChip> {
  final List<String> foodTypes = [
    "Anything",
    "Breakfast",
    "Dinner",
    "Main course",
    "Snacks",
    "Dessert",
    "Hard drinks",
    "Soft drinks",
  ];

  int _selectedIndex = 0;
  String result = '';

  @override
  Widget build(BuildContext context) {
    final chips = foodTypes.asMap().entries.map((entry) {
      final index = entry.key;
      final foodTypes = entry.value;

      return Padding(
        padding: index == 0
            ? const EdgeInsets.only(left: 18, right: 10)
            : const EdgeInsets.only(right: 10),
        child: ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),

          showCheckmark: false,
          label: Text(foodTypes),
          selected: _selectedIndex == index,
          onSelected: (selected) =>
              _handleSelection(selected, index, foodTypes),
          selectedColor: AppColors.blackColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.blackColor),
            borderRadius: BorderRadiusGeometry.circular(30),
          ),
          labelStyle: TextStyle(
            color: _selectedIndex == index
                ? AppColors.whiteColor
                : AppColors.blackColor,
          ),
          backgroundColor: AppColors.whiteColor,
        ),
      );
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: widget.padding,
        child: Row(children: chips),
      ),
    );
  }

  void _handleSelection(bool selected, int index, String foodType) {
    if (selected) {
      setState(() => _selectedIndex = index);
      widget.onFoodTypeSelected?.call(foodType);
    }
  }
}
