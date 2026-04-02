import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class EnableDisableNotificationsWidget extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  const EnableDisableNotificationsWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: Row(
        children: [
          Switch(value: value, onChanged: onChanged),
          SizedBox(width: 12,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value
                      ? "Disable push notifications"
                      : "Enable push notifications",
                  style: AppTextStyles.title,
                ),
                
                Text(
                  value
                      ? "You will not receive any notifications from this application if you disable notification"
                      : "You will receive all the notifications from this application with include new updates and feature",
                      softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
