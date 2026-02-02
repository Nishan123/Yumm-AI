import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class CustomChoiceChip<T> extends StatefulWidget {
  final List<T> values;
  final String Function(T) labelBuilder;
  final IconData? Function(T)? iconBuilder;
  final void Function(T)? onSelected;
  final EdgeInsetsGeometry padding;
  final T? selectedValue;

  const CustomChoiceChip({
    super.key,
    required this.values,
    required this.labelBuilder,
    required this.iconBuilder,
    this.onSelected,
    this.padding = const EdgeInsets.only(right: 16),
    this.selectedValue,
  });

  @override
  State<CustomChoiceChip<T>> createState() => _CustomChoiceChipState<T>();
}

class _CustomChoiceChipState<T> extends State<CustomChoiceChip<T>> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _initializeSelectedIndex();
  }

  @override
  void didUpdateWidget(CustomChoiceChip<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      _initializeSelectedIndex();
    }
  }

  void _initializeSelectedIndex() {
    if (widget.selectedValue != null) {
      final index = widget.values.indexOf(widget.selectedValue as T);
      _selectedIndex = index >= 0 ? index : 0;
    } else {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chips = widget.values.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final label = widget.labelBuilder(item);
      final icon = widget.iconBuilder?.call(item);

      return Padding(
        padding: index == 0
            ? const EdgeInsets.only(left: 18, right: 10)
            : const EdgeInsets.only(right: 10),
        child: ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          showCheckmark: false,
          label: Row(
            spacing: icon == null ? 0 : 8,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon == null
                  ? SizedBox()
                  : Icon(
                      icon,
                      size: 20,
                      color: _selectedIndex == index
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
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
