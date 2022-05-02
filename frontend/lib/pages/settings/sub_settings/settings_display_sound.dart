import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../widgets/speaq_appbar.dart';
import '../../../widgets/speaq_bottom_logo.dart';
import '../../../widgets/speaq_settings_section.dart';

class DisplaySoundSettingsPage extends StatefulWidget {
  const DisplaySoundSettingsPage({Key? key}) : super(key: key);

  @override
  State<DisplaySoundSettingsPage> createState() =>
      _DisplaySoundSettingsPageState();
}

class _DisplaySoundSettingsPageState extends State<DisplaySoundSettingsPage> {
  bool valuePrivateSwitch = false;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          title: const Text(
            "Notifications",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Stack(children: [
          SettingsList(
            sections: [
              SpqSettingsSection(
                title: const Padding(
                  padding: EdgeInsets.all(25.0),
                ),
                tiles: [
                  //Darkmode SwitchTile
                  buildSettingsSwitchTile("Darkmode"),
                ],
              ),
            ],
          ),
          Positioned(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: SpeaqBottomLogo(deviceSize: deviceSize)),
            bottom: 20,
            height: deviceSize.height * 0.1,
          )
        ]),
      ),
    );
  }

  SettingsTile buildSettingsSwitchTile(String text) {
    return SettingsTile.switchTile(
      title: Text(text, style: const TextStyle(fontSize: 15)),
      initialValue: valuePrivateSwitch,
      onToggle: (value) {
        setState(() {
          valuePrivateSwitch = value;
        });
      },
    );
  }
}
