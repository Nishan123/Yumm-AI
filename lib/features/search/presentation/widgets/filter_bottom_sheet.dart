import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/widgets/primary_button.dart';
import 'package:yumm_ai/features/search/presentation/state/search_state.dart';
import 'package:yumm_ai/features/search/presentation/view_model/search_view_model.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  String? _experienceLevel;
  String? _mealType;
  RangeValues _calories = const RangeValues(0, 2000);

  @override
  void initState() {
    super.initState();
    final filters = ref.read(searchViewModelProvider).filters;
    _experienceLevel = filters.experienceLevel;
    _mealType = filters.mealType;
    if (filters.minCalorie != null && filters.maxCalorie != null) {
      _calories = RangeValues(filters.minCalorie!, filters.maxCalorie!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Filter Search", style: AppTextStyles.title.copyWith(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  setState(() {
                    _experienceLevel = null;
                    _mealType = null;
                    _calories = const RangeValues(0, 2000);
                  });
                },
                child: Text(
                  "Reset",
                  style: AppTextStyles.h6.copyWith(color: AppColors.redColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text("Experience Level", style: AppTextStyles.h6),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: CookingExpertise.values.map((expertise) {
              return _buildChip(expertise.text, expertise.value);
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text("Meal Type", style: AppTextStyles.h6),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: Meal.values.where((meal) => meal != Meal.anything).map((
              meal,
            ) {
              return _buildChip(meal.text, meal.value, isMealType: true);
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Calories", style: AppTextStyles.h6),
              Text(
                "${_calories.start.round()} - ${_calories.end.round()} kcal",
                style: AppTextStyles.descriptionText.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _calories,
            min: 0,
            max: 2000,
            divisions: 20,
            activeColor: AppColors.primaryColor,
            inactiveColor: Colors.grey[300],
            onChanged: (values) {
              setState(() {
                _calories = values;
              });
            },
          ),
          const SizedBox(height: 30),
          PrimaryButton(
            text: "Apply Filters",
            onTap: () {
              ref
                  .read(searchViewModelProvider.notifier)
                  .setFilters(
                    SearchFilters(
                      experienceLevel: _experienceLevel,
                      mealType: _mealType,
                      minCalorie: _calories.start,
                      maxCalorie: _calories.end,
                    ),
                  );
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value, {bool isMealType = false}) {
    final isSelected = isMealType
        ? _mealType == value
        : _experienceLevel == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (isMealType) {
            _mealType = selected ? value : null;
          } else {
            _experienceLevel = selected ? value : null;
          }
        });
      },
      selectedColor: AppColors.primaryColor,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
        ),
      ),
      showCheckmark: false,
    );
  }
}
