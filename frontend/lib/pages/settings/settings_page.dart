import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsScreen(
        children: [
          SettingsGroup(title: "First Settings Group", children: [
            SimpleSettingsTile(
              title: "Settings Tile",
              child: Text("H"),
              onTap: () => print("hh"),
            ),
            SwitchSettingsTile(title: "Switch Tile", settingKey: "switch_key"),
          ]),
          SettingsGroup(title: "Second Settings Group", children: [
            CheckboxSettingsTile(title: "Checkbox Tile", settingKey: "checkbox_key"),
            DropDownSettingsTile(title: "Drop Down Tile", settingKey: "drop_down_key", selected: 0, values: {0: "Null", 1: "Eins", 2: "Zwei"}),
            SliderSettingsTile(title: "Slider Tile", settingKey: "slider_key", min: 0, max: 4),
          ])
        ],
      ),
    );
  }
}
