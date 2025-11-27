import 'package:flutter/material.dart';
import 'package:yumm_ai/screens/home/widgets/home_food_recommendations.dart';

class RecommendedFoodScrollSnap extends StatefulWidget {
  const RecommendedFoodScrollSnap({super.key});

  @override
  State<RecommendedFoodScrollSnap> createState() =>
      _RecommendedFoodScrollSnapState();
}

class _RecommendedFoodScrollSnapState extends State<RecommendedFoodScrollSnap> {
  final _controller = PageController(viewportFraction: 0.82);
  int focusedIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      width: double.infinity,
      child: PageView.builder(
        padEnds: false,
        controller: _controller,
        itemCount: 10,
        onPageChanged: (i) => setState(() => focusedIndex = i),
        itemBuilder: (context, index) {
          final isFocused = index == focusedIndex;
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(
              left: isFocused ? 18 : 0,
              right: 12,
              top: isFocused ? 0 : 40,
              bottom: isFocused ? 0 : 0,
            ),
            child: HomeFoodRecommendations(
              mainFontSize: isFocused ? 18 : 16,
              iconsSize: isFocused ? 18 : 14,
              normalFontSize: isFocused ? 14 : 10,
            ),
          );
        },
      ),
    );
  }
}
