import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:frontend/utils/all_utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  initState() {
    super.initState();
  }

  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SettingsList(
        sections: [
          SpqSettingsSection(
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "@eric",
                style: TextStyle(
                    color: spqBlack, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            tiles: [
              buildSettingsTile("Account"),
              buildSettingsTile("Privacy and safety"),
              buildSettingsTile("Notifications"),
              buildSettingsTile("Content preferences"),
            ],
          ),
          SpqSettingsSection(
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "General",
                style: TextStyle(
                    color: spqBlack, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            tiles: [
              buildSettingsTile("Display and Sound"),
              buildSettingsTile("Data usage"),
              buildSettingsTile("Accessibility"),
              buildSettingsTile("About speaq"),
            ],
          )
        ],
      ),
    );
  }

  SettingsTile buildSettingsTile(String text) {
    return SettingsTile.navigation(
      trailing: Icon(Icons.adaptive.arrow_back),
      title: Text(text),
      onPressed: (context) => print("Pressed:" + text),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        "settings and privacy",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      centerTitle: true,
      leadingWidth: 80,
      actions: [
        TextButton(
          onPressed: () => log("done"),
          child: const Text("Done"),
        ),
      ],
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
        Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 24.0),
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
