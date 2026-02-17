import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:yumm_ai/core/utils/navigator_key.dart';
import 'package:yumm_ai/features/bug_report/presentation/widgets/report_bug_bottom_sheet.dart';
import 'package:yumm_ai/features/bug_report/presentation/providers/screenshot_provider.dart';

final shakeDetectorProvider = Provider<void>((ref) {
  const double shakeThresholdGravity = 6.5;
  const int shakeSlopTimeMs = 500;
  int lastShakeTimestamp = 0;
  bool isBottomSheetOpen = false;

  final subscription = accelerometerEventStream().listen((
    AccelerometerEvent event,
  ) async {
    final double gX = event.x / 9.8;
    final double gY = event.y / 9.8;
    final double gZ = event.z / 9.8;

    final double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

    if (gForce > shakeThresholdGravity) {
      final int now = DateTime.now().millisecondsSinceEpoch;

      if (lastShakeTimestamp + shakeSlopTimeMs > now) {
        return;
      }

      // Check if bottom sheet is already open
      if (isBottomSheetOpen) {
        return;
      }

      lastShakeTimestamp = now;

      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        isBottomSheetOpen = true; // Mark as open

        try {
          final screenshotController = ref.read(screenshotControllerProvider);
          final screenshot = await screenshotController.capture();

          if (context.mounted) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  ReportBugBottomSheet(screenshot: screenshot),
            ).whenComplete(() {
              isBottomSheetOpen = false; // Reset when closed
            });
          } else {
            isBottomSheetOpen = false; // Reset if context not mounted
          }
        } catch (e) {
          debugPrint("Error capturing screenshot: $e");
          // Still show bottom sheet even if screenshot fails
          if (context.mounted) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => const ReportBugBottomSheet(),
            ).whenComplete(() {
              isBottomSheetOpen = false; // Reset when closed
            });
          } else {
            isBottomSheetOpen = false; // Reset if context not mounted
          }
        }
      }
    }
  });

  ref.onDispose(() {
    subscription.cancel();
  });
});
