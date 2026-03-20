import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class SocialAuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool? isLoading;
  final Color backgroundColor;
  final String icon;
  const SocialAuthButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ?? false ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),

        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(width: 2),
          color: backgroundColor
        ),
        child: isLoading ?? false
            ? Center(
                child: SizedBox(
                  height: 21,
                  width: 21,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 22,
                    width: 22,
                    child: CachedNetworkImage(
                      imageUrl:
                          icon,
                    ),
                  ),
                  Text(text, style: AppTextStyles.h6),
                  SizedBox(),
                ],
              ),
      ),
    );
  }
}
