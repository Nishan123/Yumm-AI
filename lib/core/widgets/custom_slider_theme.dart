// Custom track shape that draws tick marks underneath
import 'package:flutter/material.dart';

class CustomSliderTheme extends RoundedRectSliderTrackShape {
  const CustomSliderTheme({
    this.tickMarkWidth = 1.5,
    this.tickMarkHeight = 30,
    this.tickCount = 12,
  });

  final double tickMarkWidth;
  final double tickMarkHeight;
  final int tickCount;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 2,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Inset tick marks horizontally so they do not touch the track edges
    const double tickInset = 8;
    final double tickStart = trackRect.left + tickInset;
    final double tickEnd = trackRect.right - tickInset;
    final double tickSpan = (tickEnd - tickStart).clamp(0, double.infinity);

    // Calculate tick mark positions
    for (int i = 0; i < tickCount; i++) {
      final double fraction = tickCount == 1 ? 0 : i / (tickCount - 1);
      final double dx = tickStart + (tickSpan * fraction);
      final Paint tickPaint = Paint()
        ..color = Colors.grey.shade400
        ..strokeWidth = tickMarkWidth
        ..strokeCap = StrokeCap.round;

      context.canvas.drawLine(
        Offset(dx, trackRect.center.dy - tickMarkHeight / 2),
        Offset(dx, trackRect.center.dy + tickMarkHeight / 2),
        tickPaint,
      );
    }

    // Draw track ON TOP of tick marksR
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
    );
  }
}
