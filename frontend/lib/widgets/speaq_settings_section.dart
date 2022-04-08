import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../utils/speaq_styles.dart';

class SpqSettingsSection extends AbstractSettingsSection {
  const SpqSettingsSection({
    required this.tiles,
    this.margin,
    this.title,
    Key? key,
  }) : super(key: key);

  final List<Widget> tiles;
  final EdgeInsetsDirectional? margin;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 24.0),
            child: title),
        Container(
          child: Column(
            children: tiles,
          ),
          decoration: const BoxDecoration(
              color: spqWhite,
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
        )
      ],
    );
  }
}