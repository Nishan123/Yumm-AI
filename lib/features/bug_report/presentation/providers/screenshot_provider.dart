import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

final screenshotControllerProvider = Provider<ScreenshotController>((ref) {
  return ScreenshotController();
});
