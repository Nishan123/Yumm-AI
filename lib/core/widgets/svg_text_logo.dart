import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';

class SvgTextLogo extends StatelessWidget {
  final double? size;
  const SvgTextLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("${ConstantsString.assetSvg}/text_logo.svg", width: size??140),
      ],
    );
  }
}
