import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/data/models/instruction_model.dart';

class InstructionListTile extends StatefulWidget {
  final Color borderColor;
  final InstructionModel instruction;
  final int stepCount;
  final Color stepColor;
  final int index;
  final bool isLast;
  final Function(bool?)? onChecked;

  const InstructionListTile({
    super.key,
    required this.borderColor,
    required this.instruction,
    required this.stepCount,
    required this.stepColor,
    required this.index,
    this.isLast = false,
    this.onChecked,
  });

  @override
  State<InstructionListTile> createState() => _InstructionListTileState();
}

class _InstructionListTileState extends State<InstructionListTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _popController;
  late final Animation<double> _popScale;

  late bool _wasChecked;

  @override
  void initState() {
    super.initState();
    _wasChecked = widget.instruction.isDone;

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
  void didUpdateWidget(InstructionListTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.instruction.isDone == _wasChecked) return;
    _wasChecked = widget.instruction.isDone;

    if (widget.instruction.isDone) {
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
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: widget.instruction.isDone
                        ? null
                        : Border.all(width: 1.5, color: AppColors.primaryColor),
                    color: widget.instruction.isDone
                        ? AppColors.primaryColor
                        : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                    child: widget.instruction.isDone
                        ? Icon(
                            Icons.check,
                            key: const ValueKey('icon'),
                            color: AppColors.whiteColor,
                            size: 18,
                          )
                        : Text(
                            widget.index.toString(),
                            key: const ValueKey('text'),
                            style: AppTextStyles.h6.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: AppColors.primaryColor.withAlpha(128),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AnimatedBuilder(
                animation: _popController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _popScale.value,
                    alignment: Alignment.centerLeft,
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    if (widget.onChecked != null) {
                      widget.onChecked!(!widget.instruction.isDone);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(left: 0, right: 16, top: 0, bottom: 12),
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 6),
                    decoration: BoxDecoration(
                      color: widget.instruction.isDone
                          ? AppColors.primaryColor.withAlpha(20)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 0.6,
                        color: widget.instruction.isDone
                            ? AppColors.primaryColor.withAlpha(128)
                            : widget.borderColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.descriptionText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: widget.instruction.isDone
                                      ? AppColors.descriptionTextColor.withAlpha(128)
                                      : AppColors.descriptionTextColor,
                                  decoration: widget.instruction.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                children: [
                                  const TextSpan(text: "Step: "),
                                  TextSpan(
                                    text: widget.stepCount.toString(),
                                    style: AppTextStyles.descriptionText.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: widget.instruction.isDone
                                          ? widget.stepColor.withAlpha(128)
                                          : widget.stepColor,
                                      decoration: widget.instruction.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: widget.instruction.isDone,
                              onChanged: widget.onChecked,
                              activeColor: AppColors.primaryColor,
                            ),
                          ],
                        ),
                        const Divider(thickness: 0.6),
                        Text(
                          widget.instruction.instruction,
                          style: widget.instruction.isDone
                              ? TextStyle(
                                  fontSize: 14,
                                  color: AppColors.descriptionTextColor.withAlpha(128),
                                  decoration: TextDecoration.lineThrough,
                                )
                              : AppTextStyles.normalText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
