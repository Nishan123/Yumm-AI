import 'package:flutter/material.dart';

class EmptyCookbookStateWidget extends StatelessWidget {
  const EmptyCookbookStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height *0.7,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Your cookbook is empty.\nAdd recipes from the home feed to start cooking!',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
  }
}