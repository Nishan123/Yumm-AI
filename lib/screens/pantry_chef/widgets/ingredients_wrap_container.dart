import 'package:flutter/material.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/container_property.dart';

class IngredientsWrapContainer extends StatelessWidget {
  final List<Widget> items;

  const IngredientsWrapContainer({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Constants.commonPadding,
      padding: EdgeInsets.only(left: 11, top: 10, bottom: 8, right: 0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.extraLightBlackColor,
        borderRadius: BorderRadius.circular(28),
        border: ContainerProperty.mainBorder,
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: Wrap(children: [...items]),
    );
  }
}
