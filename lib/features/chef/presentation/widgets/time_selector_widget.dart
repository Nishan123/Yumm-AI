import 'package:flutter/cupertino.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class TimeSelectorWidget extends StatefulWidget {
  final Duration initialDuration;
  final ValueChanged<Duration> onTimerDurationChanged;

  const TimeSelectorWidget({
    super.key,
    required this.initialDuration,
    required this.onTimerDurationChanged,
  });

  @override
  State<TimeSelectorWidget> createState() => _TimeSelectorWidgetState();
}

class _TimeSelectorWidgetState extends State<TimeSelectorWidget> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _secondController;

  @override
  void initState() {
    super.initState();
    final int hours = widget.initialDuration.inHours;
    final int minutes = widget.initialDuration.inMinutes % 60;
    final int seconds = widget.initialDuration.inSeconds % 60;

    _hourController = FixedExtentScrollController(initialItem: hours);
    _minuteController = FixedExtentScrollController(initialItem: minutes);
    _secondController = FixedExtentScrollController(initialItem: seconds);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  void _onTimerChanged() {
    final duration = Duration(
      hours: _hourController.selectedItem,
      minutes: _minuteController.selectedItem,
      seconds: _secondController.selectedItem,
    );
    widget.onTimerDurationChanged(duration);
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required int count,
  }) {
    return CupertinoPicker(
      squeeze: 1,
      diameterRatio: 80,
      useMagnifier: true,
      scrollController: controller,
      itemExtent: 40,
      selectionOverlay: Container(),
      onSelectedItemChanged: (int index) {
        _onTimerChanged();
      },
      children: List<Widget>.generate(count, (int index) {
        return Center(
          child: Text(
            index.toString().padLeft(2, '0'),
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: AppColors.blackColor,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );

    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: AppColors.borderColor,
                  width: 0.6,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildPicker(controller: _hourController, count: 24, ),
              ),
              Text(":", style: textStyle),
              Expanded(
                child: _buildPicker(controller: _minuteController, count: 60),
              ),
              Text(":", style: textStyle),
              Expanded(
                child: _buildPicker(controller: _secondController, count: 60),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
