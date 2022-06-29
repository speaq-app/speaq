import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/pages/all_pages_export.dart';

/// Custom logo used for instance in [SettingsPage].
class SpeaqBottomLogo extends StatelessWidget {
  const SpeaqBottomLogo({
    Key? key, required this.deviceSize,
  }) : super(key: key);
  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: deviceSize.width,
      child: SvgPicture.asset("assets/images/logo/speaq_text_logo.svg",
          height: deviceSize.height * 0.05, width: deviceSize.width * 0.3),
    );
  }
}