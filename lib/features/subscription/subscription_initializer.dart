import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io';

Future<void> initializeRevenueCat() async {
  // Platform-specific API keys injected via --dart-define
  String apiKey;
  if (Platform.isIOS) {
    apiKey = const String.fromEnvironment('REVENUE_CAT_API_KEY', defaultValue: '');
    if (apiKey.isEmpty) apiKey = dotenv.env['REVENUE_CAT_API_KEY'] ?? '';
  } else if (Platform.isAndroid) {
    apiKey = const String.fromEnvironment('REVENUE_CAT_API_KEY', defaultValue: '');
    if (apiKey.isEmpty) apiKey = dotenv.env['REVENUE_CAT_API_KEY'] ?? '';
  } else {
    throw UnsupportedError('Platform not supported');
  }

  if (apiKey.isNotEmpty) {
    await Purchases.configure(PurchasesConfiguration(apiKey));
  } else {
    debugPrint(
      'RevenueCat API key not found. Make sure to provide it via --dart-define',
    );
  }
}
