import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class DisplaySoundSettingsPage extends StatefulWidget {
  const DisplaySoundSettingsPage({Key? key}) : super(key: key);

  @override
  State<DisplaySoundSettingsPage> createState() => _DisplaySoundSettingsPageState();
}

class _DisplaySoundSettingsPageState extends State<DisplaySoundSettingsPage> {
  bool valuePrivateSwitch = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          title: Text(
            appLocale.displayAndSound,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
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
                  buildSettingsSwitchTile(appLocale.darkMode),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            height: deviceSize.height * 0.1,
            child: Align(alignment: Alignment.bottomCenter, child: SpeaqBottomLogo(deviceSize: deviceSize)),
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
