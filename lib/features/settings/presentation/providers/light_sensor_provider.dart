import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_sensor/light_sensor.dart';

// Threshold below which the app should switch to dark theme when in auto mode.
const double kLowLightThresholdLux = 10.0;

final lightSensorProvider = StreamProvider<double>((ref) {
  final controller = StreamController<double>();
  StreamSubscription<int>? subscription;

  void startListening() async {
    try {
      final hasSensor = await LightSensor.hasSensor();
      if (!hasSensor) {
        debugPrint("Light sensor not available on this device");
        return;
      }
      subscription ??= LightSensor.luxStream().listen(
        (lux) => controller.add(lux.toDouble()),
        onError: controller.addError,
      );
    } catch (error) {
      debugPrint("Light sensor error: $error");
    }
  }

  void stopListening() {
    subscription?.cancel();
    subscription = null;
  }

  final observer = AppLifecycleListener(
    onResume: startListening,
    onPause: stopListening,
    onDetach: stopListening,
    onInactive: stopListening,
  );

  ref.onDispose(() {
    stopListening();
    observer.dispose();
    controller.close();
  });

  startListening();

  return controller.stream;
});
