import 'package:flutter/material.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_settings_section.dart';
import 'package:frontend/widgets/speaq_bottom_logo.dart';
import 'package:settings_ui/settings_ui.dart';

class PrivacySafetySettingsPage extends StatefulWidget {
  const PrivacySafetySettingsPage({Key? key}) : super(key: key);

  @override
  State<PrivacySafetySettingsPage> createState() =>
      _PrivacySafetySettingsPageState();
}

class _PrivacySafetySettingsPageState extends State<PrivacySafetySettingsPage> {
  bool valuePrivateSwitch = false;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          title: const Text(
            "Privacy and safety",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
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
                //Privates Konto SwitchTile
                SettingsTile.switchTile(
                  title: const Text("Privates Konto", style: TextStyle(fontSize: 15)),
                  initialValue: valuePrivateSwitch,
                  onToggle: (value) {
                    setState(() {
                      valuePrivateSwitch = value;
                    });
                  },
                ),
                tiles: [
                  //Privates Konto SwitchTile
                  SettingsTile.switchTile(
                    title: Text("Privates Konto", style: TextStyle(fontSize: 15)),
                    initialValue: valuePrivateSwitch,
                    onToggle: (value) {
                      setState(() {
                        valuePrivateSwitch = value;
                      });
                    },
                  ),
                  //Suchverlauf löschen
                  _buildPopUpWindow(
                      "Suchverlauf löschen",
                      "Bist du dir sicher, dass du den Suchverlauf löschen möchtest?",
                      "Löschen"),
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

  //Pop-up-Fenster
  SettingsTile _buildPopUpWindow(
      String text, String popupMessage, String exitText) {
    return SettingsTile.navigation(
        trailing: Icon(Icons.adaptive.arrow_forward),
        title: Text(text, style: const TextStyle(fontSize: 15)),
        onPressed: (context) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(popupMessage),
                  actions: [
                    TextButton(
                        child: Text(exitText),
                        onPressed: () => Navigator.pop(context)),
                    TextButton(
                        child: const Text("Abbrechen"),
                        onPressed: () => Navigator.pop(context)),
                  ],
                )));
  }
}
