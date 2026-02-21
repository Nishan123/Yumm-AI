import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_sensor/light_sensor.dart';

// Threshold below which the app should switch to dark theme when in auto mode.
const double kLowLightThresholdLux = 10.0;

final lightSensorProvider = StreamProvider<double>((ref) async* {
  try {
    final hasSensor = await LightSensor.hasSensor();
    if (!hasSensor) {
      debugPrint("Light sensor not available on this device");
      return;
    }

    await for (final lux in LightSensor.luxStream()) {
      yield lux.toDouble();
    }
  } catch (error) {
    debugPrint("Light sensor error: $error");
  }
});
