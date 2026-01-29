import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/primary_icon_button.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';

class KitchenToolsCard extends StatelessWidget {
  final int index;
  final KitchenToolModel kitchenTool;
  const KitchenToolsCard({super.key, required this.index, required this.kitchenTool});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(
              top: 6,
              bottom: 6,
              left: index % 2 == 0 ? 0 : 3,
              right: index % 2 == 0 ? 3 : 0,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppColors.extraLightBlackColor,
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(12),
                    child: kitchenTool.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: kitchenTool.imageUrl,
                            errorWidget: (context, url, error) {
                              return Icon(LucideIcons.camera_off);
                            },
                          )
                        : Icon(LucideIcons.camera_off),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Transform.scale(
                    filterQuality: FilterQuality.high,
                    alignment: Alignment.topRight,
                    scale: 0.6,
                    child: PrimaryIconButton(
                      iconColor: AppColors.redColor,
                      icon: LucideIcons.x,
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Kitchen Tool name sak djak asdk ka sdka ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.normalText.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
