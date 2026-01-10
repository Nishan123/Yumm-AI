import 'package:flutter/material.dart';
import 'package:yumm_ai/core/widgets/custom_slider_theme.dart';

class CustomSlider extends StatelessWidget {
  final Function(double) onChange;
  final double value;
  const CustomSlider({super.key, required this.onChange, required this.value});

  @override
  Widget build(BuildContext context) {
    return // People Count Slider
    SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.grey.shade600,
        inactiveTrackColor: Colors.grey.shade300,
        trackHeight: 15,
        thumbColor: const Color(0xFFFF9999),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
        overlayColor: const Color(0xFFFF9999).withOpacity(0.2),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
        trackShape: const CustomSliderTheme(
          tickCount: 12,
          tickMarkWidth: 1.5,
          tickMarkHeight: 36,
        ),
        tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 0),
      ),
      child: Slider(
        min: 1,
        max: 12,
        divisions: 11,
        value: value.clamp(1, 12).toDouble(),
        onChanged: (val) => onChange(val.clamp(1, 12).toDouble()),
      ),
    );
  }
}
