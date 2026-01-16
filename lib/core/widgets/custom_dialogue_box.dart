import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class CustomDialogueBox {
  /// Shows a branded alert dialog with an optional secondary action.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    Color? titleColor,
    String okText = 'OK',
    VoidCallback? onOkTap,
    String? actionButtonText,
    VoidCallback? onActionButtonTap,
    bool barrierDismissible = true,
    IconData? icons
  }) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    await showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        icons?? LucideIcons.info,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: titleColor ?? colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 22
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          onOkTap?.call();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightBlackColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(okText),
                      ),
                      if (actionButtonText != null &&
                          actionButtonText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              onActionButtonTap?.call();
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(actionButtonText),
                          ),
                        ),
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
