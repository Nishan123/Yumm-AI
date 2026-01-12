import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';

class IngredientsWrapContainer extends StatelessWidget {
  final List<Widget> items;
  final EdgeInsets? margin;
  final String? emptyText;
  final bool? haveAddIngredientButton;
  final VoidCallback? onAddIngredientButtonPressed;

  const IngredientsWrapContainer({
    super.key,
    required this.items,
    this.margin,
    this.emptyText,
    this.haveAddIngredientButton,
    this.onAddIngredientButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? ConstantsString.commonPadding,
      padding: EdgeInsets.only(left: 11, top: 10, bottom: 8, right: 0),
      width: double.infinity,
      height: items.isEmpty ? 120 : null,
      decoration: BoxDecoration(
        color: AppColors.extraLightBlackColor,
        borderRadius: BorderRadius.circular(28),
        border: ContainerProperty.mainBorder,
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emptyText ?? "No Ingredients Selected 😪",
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.descriptionTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  haveAddIngredientButton ?? false
                      ? SizedBox(height: 12)
                      : SizedBox(),
                  haveAddIngredientButton ?? false
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.blackColor,
                            foregroundColor: AppColors.whiteColor,
                          ),
                          onPressed: onAddIngredientButtonPressed,
                          child: Text("Add Item"),
                        )
                      : SizedBox(),
                ],
              ),
            )
          : Wrap(children: [...items]),
    );
  }
}
