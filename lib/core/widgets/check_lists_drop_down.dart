import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';

class CustomDropdownChecklist extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;
  final Function(List<String>) onConfirm;

  const CustomDropdownChecklist({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onConfirm,
  });

  @override
  State<CustomDropdownChecklist> createState() => _CustomDropdownChecklistState();
}

class _CustomDropdownChecklistState extends State<CustomDropdownChecklist> {
  bool isExpanded = false;
  late List<String> tempSelectedOptions;

  @override
  void initState() {
    super.initState();
    tempSelectedOptions = List.from(widget.selectedOptions);
  }

  String get displayText {
    if (tempSelectedOptions.isEmpty) {
      return widget.title;
    } else if (tempSelectedOptions.length == 1) {
      return tempSelectedOptions.first;
    } else {
      return '${tempSelectedOptions.length} selected';
    }
  }

  void toggleOption(String option) {
    setState(() {
      if (tempSelectedOptions.contains(option)) {
        tempSelectedOptions.remove(option);
      } else {
        tempSelectedOptions.add(option);
      }
    });
  }

  void confirm() {
    widget.onConfirm(tempSelectedOptions);
    setState(() {
      isExpanded = false;
    });
  }

  void cancel() {
    setState(() {
      tempSelectedOptions = List.from(widget.selectedOptions);
      isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header/Trigger Button
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
                if (isExpanded) {
                  tempSelectedOptions = List.from(widget.selectedOptions);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isExpanded ? AppColors.primaryColor : AppColors.lightPrimaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    displayText,
                    style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.w500)
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
      
          // Dropdown Content
          if (isExpanded) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Options List
                  ...widget.options.map((option) {
                    final isSelected = tempSelectedOptions.contains(option);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => toggleOption(option),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              option,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
      
                  const SizedBox(height: 8),
      
                  // Confirm Button
                  SecondaryButton(
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    backgroundColor: AppColors.primaryColor, onTap: confirm, text: "Confirm Saves")
                   
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
