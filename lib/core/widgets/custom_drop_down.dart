import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';

class CustomDropDown extends StatefulWidget {
  final String title;
  final List<String> options;
  final String selectedOptions;
  final Function(String) onConfirm;
  final String? Function(String?)? validator;

  const CustomDropDown({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onConfirm,
    this.validator,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool isExpanded = false;
  late String tempSelectedOptions;

  @override
  void initState() {
    super.initState();
    tempSelectedOptions = (widget.selectedOptions);
  }

  String get displayText {
    if (tempSelectedOptions.isEmpty) {
      return widget.title;
    } else {
      return tempSelectedOptions;
    }
  }

  void toggleOption(String option) {
    setState(() {
      // Single-select: tap toggles between selected option and none.
      tempSelectedOptions = tempSelectedOptions == option ? '' : option;
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
      tempSelectedOptions = (widget.selectedOptions);
      isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FormField<String>(
        initialValue: widget.selectedOptions,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (formState) {
          void toggleOption(String option) {
            setState(() {
              tempSelectedOptions = tempSelectedOptions == option ? '' : option;
            });
            formState.didChange(tempSelectedOptions);
          }

          void confirm() {
            widget.onConfirm(tempSelectedOptions);
            formState.didChange(tempSelectedOptions);
            setState(() {
              isExpanded = false;
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header/Trigger Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                    if (isExpanded) {
                      tempSelectedOptions = widget.selectedOptions;
                    }
                  });
                  formState.didChange(tempSelectedOptions);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isExpanded
                          ? AppColors.primaryColor
                          : AppColors.lightBlackColor,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayText,
                        style: AppTextStyles.h6.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),

              // Dropdown Content
              if (isExpanded) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Options List
                      ...widget.options.map((option) {
                        final isSelected = tempSelectedOptions == option;
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
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.whiteColor,
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
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        backgroundColor: AppColors.primaryColor,
                        onTap: confirm,
                        text: "Confirm Saves",
                      ),
                    ],
                  ),
                ),
              ],

              if (formState.hasError) ...[
                const SizedBox(height: 8),
                Text(
                  formState.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
