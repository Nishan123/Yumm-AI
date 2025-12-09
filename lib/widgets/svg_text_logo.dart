import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yumm_ai/core/consts/constants.dart';

class SvgTextLogo extends StatelessWidget {
  final double? size;
  const SvgTextLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("${Constants.assetSvg}/text_logo.svg", width: size??140),
      ],
    );
  }
}
