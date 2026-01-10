import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/time_selector_widget.dart';

class AvailableTimeSelector extends StatelessWidget {
  const AvailableTimeSelector({
    super.key,
    required this.mq,
    required this. selectedDuration,
    required this. onDurationChange,
    this.margin
  });

  final Size mq;
  final Duration selectedDuration;
  final ValueChanged<Duration> onDurationChange;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin??ConstantsString.commonPadding,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 6),
      width: mq.width,
      height: mq.height * 0.18,
      decoration: BoxDecoration(
        color: AppColors.extraLightBlackColor,
        borderRadius: BorderRadius.circular(28),
        border: ContainerProperty.mainBorder,
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: TimeSelectorWidget(
        initialDuration: selectedDuration,
        onTimerDurationChanged: onDurationChange,
      ),
    );
  }
}
