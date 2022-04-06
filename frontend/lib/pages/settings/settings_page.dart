import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../utils/all_utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String switchKey = "switchKey";
  static const String dropDownKey = "dropDownKey";
  static const String sliderKey = "sliderKey";
  static const String checkboxKey = "checkboxKey";

  @override
  initState() {
    super.initState();
  }

  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SettingsList(
        sections: [
          SpqSettingsSection(
            title: Text(
              "Servus",
              style: TextStyle(color: spqPrimaryBlue, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.logout_rounded),
                title: Text("Logout"),
                onPressed: (context) => print("Sheeesh"),
              ),
              SettingsTile.switchTile(
                  leading: Icon(Icons.dark_mode),
                  initialValue: enabled,
                  onToggle: (active) {
                    print(active);
                    enabled = !enabled;
                  },
                  title: Text("Dark Mode")),
              SettingsTile.navigation(
                trailing: Icon(Icons.adaptive.arrow_forward_rounded),
                title: Text("Weiter"),
                onPressed: (context) => print("Sheeesh"),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.emoji_people_rounded),
                trailing: Icon(Icons.adaptive.arrow_forward_rounded),
                title: Text("Sheesh"),
                onPressed: (context) => print("Sheeesh"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

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
        Container(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 24.0), child: title),
        Container(
          child: Column(
            children: tiles,
          ),
          decoration: BoxDecoration(color: spqWhite, borderRadius: BorderRadius.all(Radius.circular(24.0))),
        )
      ],
    );
  }
}

/*SettingsScreen(
        children: [
          SettingsGroup(title: "First Settings Group", children: [
            Container(
              decoration: BoxDecoration(color: spqWhite, borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                children: [
                  SimpleSettingsTile(
                    title: "Settings Tile",
                    leading: Icon(Icons.add),
                    //child: Icon(Icons.add),
                    subtitle: '',
                    onTap: () => print("hh"),
                  ),
                  SwitchSettingsTile(title: "Switch Tile", settingKey: switchKey),
                ],
              ),
            ),
          ]),
          SettingsGroup(title: "Second Settings Group", children: [
            CheckboxSettingsTile(title: "Checkbox Tile", leading: Icon(Icons.add), settingKey: checkboxKey),
            DropDownSettingsTile(title: "Drop Down Tile", settingKey: dropDownKey, selected: 0, values: {0: "Null", 1: "Eins", 2: "Zwei"}),
            SliderSettingsTile(title: "Slider Tile", leading: Icon(Icons.add), settingKey: sliderKey, min: 0, max: 4),
          ])
        ],
      )*/
/*
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
    final theme = SettingsTheme.of(context);

    switch (theme.platform) {
      case DevicePlatform.android:
      case DevicePlatform.fuchsia:
      case DevicePlatform.linux:
        return SpqAndroidSettingsSection(
          title: title,
          tiles: tiles,
          margin: margin,
        );
      case DevicePlatform.iOS:
      case DevicePlatform.macOS:
      case DevicePlatform.windows:
        return SpqIOSSettingsSection(
          title: title,
          tiles: tiles,
          margin: margin,
        );
/*
      case DevicePlatform.web:
        return SpqWebSettingsSection(
          title: title,
          tiles: tiles,
          margin: margin,
        );
*/
      case DevicePlatform.device:
        throw Exception(
          'You can\'t use the DevicePlatform.device in this context. '
          'Incorrect platform: SettingsSection.build',
        );
    }
  }
}

class SpqAndroidSettingsSection extends StatelessWidget {
  const SpqAndroidSettingsSection({
    required this.tiles,
    required this.margin,
    this.title,
    Key? key,
  }) : super(key: key);

  final List<Widget> tiles;
  final EdgeInsetsDirectional? margin;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return buildSectionBody(context);
  }

  Widget buildSectionBody(BuildContext context) {
    final theme = SettingsTheme.of(context);
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    final tileList = buildTileList();

    if (title == null) {
      return tileList;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            top: 24 * scaleFactor,
            bottom: 10 * scaleFactor,
            start: 24,
            end: 24,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: theme.themeData.titleTextColor,
            ),
            child: title!,
          ),
        ),
        Container(
          decoration: BoxDecoration(color: spqWhite, borderRadius: BorderRadius.all(Radius.circular(20.0))),
          color: theme.themeData.settingsSectionBackground,
          child: tileList,
        ),
      ],
    );
  }

  Widget buildTileList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tiles.length,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return tiles[index];
      },
    );
  }
}

class SpqIOSSettingsSection extends StatelessWidget {
  const SpqIOSSettingsSection({
    required this.tiles,
    required this.margin,
    required this.title,
    Key? key,
  }) : super(key: key);

  final List<Widget> tiles;
  final EdgeInsetsDirectional? margin;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);
    final isLastNonDescriptive = tiles.last is SettingsTile && (tiles.last as SettingsTile).description == null;
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: margin ??
          EdgeInsets.only(
            top: 14.0 * scaleFactor,
            bottom: isLastNonDescriptive ? 27 * scaleFactor : 10 * scaleFactor,
            left: 16,
            right: 16,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 18,
                bottom: 5 * scaleFactor,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: theme.themeData.titleTextColor,
                  fontSize: 13,
                ),
                child: title!,
              ),
            ),
          buildTileList(),
        ],
      ),
    );
  }

  Widget buildTileList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tiles.length,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final tile = tiles[index];

        var enableTop = false;

        if (index == 0 || (index > 0 && tiles[index - 1] is SettingsTile && (tiles[index - 1] as SettingsTile).description != null)) {
          enableTop = true;
        }

        var enableBottom = false;

        if (index == tiles.length - 1 || (index < tiles.length && tile is SettingsTile && (tile).description != null)) {
          enableBottom = true;
        }

        return IOSSettingsTileAdditionalInfo(
          enableTopBorderRadius: enableTop,
          enableBottomBorderRadius: enableBottom,
          needToShowDivider: index != tiles.length - 1,
          child: tile,
        );
      },
    );
  }
}
*/
