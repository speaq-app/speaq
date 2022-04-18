import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SpeaqBottomLogo extends StatelessWidget {
  const SpeaqBottomLogo({
    Key? key, required this.deviceSize,
  }) : super(key: key);
  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: deviceSize.width,
      child: SvgPicture.asset("assets/images/logo/logo_text.svg",
          height: deviceSize.height * 0.05, width: deviceSize.width * 0.3),
    );
  }
}