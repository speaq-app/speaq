import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsScreen(
        children: [
          SettingsGroup(title: "First Settings Group", children: [
            SimpleSettingsTile(
              title: "Settings Tile",
              leading: Icon(Icons.add),
              //child: Icon(Icons.add),
              subtitle: '',
              onTap: () => print("hh"),
            ),
            SwitchSettingsTile(title: "Switch Tile", settingKey: switchKey),
          ]),
          SettingsGroup(title: "Second Settings Group", children: [
            CheckboxSettingsTile(title: "Checkbox Tile", leading: Icon(Icons.add), settingKey: checkboxKey),
            DropDownSettingsTile(title: "Drop Down Tile", settingKey: dropDownKey, selected: 0, values: {0: "Null", 1: "Eins", 2: "Zwei"}),
            SliderSettingsTile(title: "Slider Tile", leading: Icon(Icons.add), settingKey: sliderKey, min: 0, max: 4),
          ])
        ],
      ),
    );
  }
}
