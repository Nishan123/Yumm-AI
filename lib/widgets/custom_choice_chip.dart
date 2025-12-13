import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';

class CustomChoiceChip<T> extends StatefulWidget {
  final List<T> values;
  final String Function(T) labelBuilder;
  final IconData Function(T) iconBuilder;
  final void Function(T)? onSelected;
  final EdgeInsetsGeometry padding;

  const CustomChoiceChip({
    super.key,
    required this.values,
    required this.labelBuilder,
    required this.iconBuilder,
    this.onSelected,
    this.padding = const EdgeInsets.only(right: 16),
  });

  @override
  State<CustomChoiceChip<T>> createState() => _CustomChoiceChipState<T>();
}

class _CustomChoiceChipState<T> extends State<CustomChoiceChip<T>> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final chips = widget.values.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final label = widget.labelBuilder(item);
      final icon = widget.iconBuilder(item);

      return Padding(
        padding: index == 0
            ? const EdgeInsets.only(left: 18, right: 10)
            : const EdgeInsets.only(right: 10),
        child: ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          showCheckmark: false,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: _selectedIndex == index
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          selected: _selectedIndex == index,
          onSelected: (selected) => _handleSelection(selected, index, item),
          selectedColor: AppColors.blackColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.blackColor),
            borderRadius: BorderRadiusGeometry.circular(30),
          ),
          labelStyle: TextStyle(
            fontSize: 15,
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

  void _handleSelection(bool selected, int index, T item) {
    if (selected) {
      setState(() => _selectedIndex = index);
      widget.onSelected?.call(item);
    }
  }
}
