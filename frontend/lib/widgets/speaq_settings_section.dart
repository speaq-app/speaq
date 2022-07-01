import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:settings_ui/settings_ui.dart';

/// Custom [SettingsSection] used in [SettingsPage] to put in more elements.
class SpqSettingsSection extends AbstractSettingsSection {
  final List<Widget> tiles;
  final EdgeInsetsDirectional? margin;
  final Widget? title;

  const SpqSettingsSection({
    required this.tiles,
    this.margin,
    this.title,
    Key? key,
  }) : super(key: key);

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
          decoration: const BoxDecoration(
              color: spqWhite,
              borderRadius: BorderRadius.all(Radius.circular(24.0))
          ),
          child: Column(
            children: tiles,
          ),
        )
      ],
    );
  }
}
