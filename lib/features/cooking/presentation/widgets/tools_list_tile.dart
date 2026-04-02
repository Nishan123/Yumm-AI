import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_kitchen_tool_model.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/cached_image_error_widget.dart';

class ToolsListTile extends StatefulWidget {
  final RecipeKitchenToolModel kitchenTool;
  final Color textColor;
  final Function(bool?)? onChecked;

  const ToolsListTile({
    super.key,
    required this.kitchenTool,
    required this.textColor,
    required this.onChecked,
  });

  @override
  State<ToolsListTile> createState() => _ToolsListTileState();
}

class _ToolsListTileState extends State<ToolsListTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _popController;
  late final Animation<double> _popScale;

  late bool _wasChecked;

  @override
  void initState() {
    super.initState();
    _wasChecked = widget.kitchenTool.isReady;

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _popScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.94,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.94,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
    ]).animate(_popController);
  }

  @override
  void didUpdateWidget(ToolsListTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.kitchenTool.isReady == _wasChecked) return;
    _wasChecked = widget.kitchenTool.isReady;

    if (widget.kitchenTool.isReady) {
      _popController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _popController,
      builder: (context, child) {
        return Transform.scale(
          scale: _popScale.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          if (widget.onChecked != null) {
            widget.onChecked!(!widget.kitchenTool.isReady);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.kitchenTool.isReady
                ? AppColors.primaryColor.withAlpha(20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 0.6,
              color: widget.kitchenTool.isReady
                  ? AppColors.primaryColor.withAlpha(128)
                  : AppColors.borderColor,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: widget.kitchenTool.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.kitchenTool.imageUrl,
                        height: 40,
                        width: 40,
                        errorWidget: (context, url, error) {
                          return CachedImageErrorWidget(
                            backgroundColor: widget.textColor,
                            icon: LucideIcons.cooking_pot,
                          );
                        },
                      )
                    : CachedImageErrorWidget(
                        backgroundColor: widget.textColor,
                        icon: LucideIcons.cooking_pot,
                      ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.kitchenTool.toolName,
                style: AppTextStyles.normalText.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.kitchenTool.isReady
                      ? widget.textColor.withAlpha(128)
                      : widget.textColor,
                  decoration: widget.kitchenTool.isReady
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              const Spacer(),
              Checkbox(
                value: widget.kitchenTool.isReady,
                onChanged: widget.onChecked,
                activeColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
