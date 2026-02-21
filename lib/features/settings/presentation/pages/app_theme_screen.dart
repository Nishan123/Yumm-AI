import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/settings/domain/entities/app_theme_entity.dart';
import 'package:yumm_ai/features/settings/presentation/providers/theme_provider.dart';
import 'package:yumm_ai/features/settings/presentation/widgets/custom_radio_button.dart';

class AppThemeScreen extends ConsumerWidget {
  const AppThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeControllerProvider);
    final controller = ref.read(appThemeControllerProvider.notifier);
    final selectedMode = themeMode.storageValue;

    void handleChange(String? value) {
      if (value == null) return;
      controller.updateTheme(appThemeModeFromStorage(value));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("App Theme")),
      body: SafeArea(
        child: Column(
          children: [
            CustomRadioButton(
              value: AppThemeMode.light.storageValue,
              groupValue: selectedMode,
              onChanged: handleChange,
              title: "Light Mode",
              description: "Just your regular light mode.",
            ),
            CustomRadioButton(
              value: AppThemeMode.dark.storageValue,
              groupValue: selectedMode,
              onChanged: handleChange,
              title: "Dark Mode",
              description: "Just your regular dark mode.",
            ),
            CustomRadioButton(
              value: AppThemeMode.system.storageValue,
              groupValue: selectedMode,
              onChanged: handleChange,
              title: "System Theme",
              description: "Same theme currently used by your device.",
            ),
            CustomRadioButton(
              value: AppThemeMode.auto.storageValue,
              groupValue: selectedMode,
              onChanged: handleChange,
              title: "Auto Theme",
              description: "Change the theme according to light intensity",
            ),

          ],
        ),
      ),
    );
  }
}
