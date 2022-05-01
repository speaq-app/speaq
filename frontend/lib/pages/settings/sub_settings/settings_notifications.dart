import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../widgets/speaq_appbar.dart';
import '../../../widgets/speaq_bottom_logo.dart';
import '../../../widgets/speaq_settings_section.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool valuePrivateSwitch = false;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
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
                //Privates Konto SwitchTile
                buildSettingsSwitchTile("Nicht stören"),
                //Methode für SettingsTile
                _buildSettingsTile("Nachrichten empfängen", "login"),
                _buildSettingsTile("Nachrichtentöne", "login"),
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
    );
  }

  //Erstelle SettingsTile
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

  SettingsTile _buildSettingsTile(String text, String route) {
    return SettingsTile.navigation(
      trailing: Icon(Icons.adaptive.arrow_forward),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      onPressed: (context) => Navigator.pushNamed(context, route),
    );
  }
}
