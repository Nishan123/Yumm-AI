import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yumm_ai/screens/cooking/widgets/tools_list_tile.dart';

class ToolsList extends StatelessWidget {
  const ToolsList({super.key});

  @override
  Widget build(BuildContext context) {
    Color _colorForIndex(int index) {
      final rnd = Random(index * 9973);
      final r = rnd.nextInt(256);
      final g = rnd.nextInt(256);
      final b = rnd.nextInt(256);
      return Color.fromARGB(77, r, g, b);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 18, left: 16),
      child: SizedBox(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          primary: false,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return ToolsListTile(
              toolName: "Microwave",
              image:
                  "https://assets.stickpng.com/images/5b51f104c051e602a568ce69.png",
              bgColor: _colorForIndex(index),
            );
          },
        ),
      ),
    );
  }
}
