import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/services/storage/notification_pref_storage.dart';
import 'package:yumm_ai/features/notifications/presentation/widgets/enable_disable_notifications_widget.dart';

class EnableDisableNotifications extends ConsumerStatefulWidget {
  const EnableDisableNotifications({super.key});

  @override
  ConsumerState<EnableDisableNotifications> createState() =>
      _EnableDisableNotificationsState();
}

class _EnableDisableNotificationsState
    extends ConsumerState<EnableDisableNotifications> {

  bool isToggleOn = true;

  late final NotificationPrefStorage notificationPref;

  @override
  void initState() {
    super.initState();

    // Properly typed provider
    notificationPref = ref.read(notificationPrefStorageProvider);

    // Load initial value safely after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isToggleOn =
            notificationPref.getCurrentNotificationPred();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification pref"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Text("Restart the app to load changes",style: TextStyle(color: AppColors.redColor),),
            const SizedBox(height: 12,),
            EnableDisableNotificationsWidget(
              value: isToggleOn,
              onChanged: (value) {
                notificationPref.storeNotificationPref(value);
                setState(() {
                  isToggleOn = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}