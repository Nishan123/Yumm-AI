import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';

class VisibilitySelector extends StatelessWidget {
  final bool isPublic;
  final ValueChanged<bool> onChanged;

  const VisibilitySelector({
    super.key,
    required this.isPublic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,),
      padding: EdgeInsets.symmetric(vertical: 4),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.extraLightBlackColor,
        boxShadow: [ContainerProperty.mainShadow],
        borderRadius: BorderRadius.circular(22),
        border: ContainerProperty.mainBorder,
      ),
      child: CheckboxListTile(
        value: isPublic,
        onChanged: (bool? value) {
          if (value != null) {
            onChanged(value);
          }
        },
        title: Text("Make this recipe public.", style: AppTextStyles.h5),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            "Do you wish to make the recipe public so that other users can try it.",
            style: AppTextStyles.descriptionText,
          ),
        ),
      ),
    );
  }
}
