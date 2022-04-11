import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/speaq_styles.dart';
import '../../widgets/speaq_appbar.dart';
import '../../widgets/speaq_settings_section.dart';
import 'package:settings_ui/settings_ui.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: SpqAppBar(
        preferredSize: deviceSize,
        scrollController: ScrollController(),
        title: const Text(
          "Account",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Stack(children: [
        SettingsList(
          sections: [
            SpqSettingsSection(
              tiles: [
                const SizedBox(
                  height: 20,
                ),
                _buildSettingsTile("Account-Informationen", "settAccount"),
                _buildSettingsTile("Passwort ändern", "login"),
                _buildPopUpWindow(
                    "Account löschen",
                    "Bist du dir sicher, dass du den Account löschen möchtest?",
                    "Löschen"),
                _buildPopUpWindow(
                    "Account abmelden",
                    "Bist du dir sicher, dass du dich abmelden möchtest?",
                    "Abmelden"),
              ],
            ),
          ],
        ),
        Positioned(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildLogoPictures(deviceSize)),
          bottom: 20,
          height: deviceSize.height * 0.1,
        )
      ]),
    );
  }

  SettingsTile _buildPopUpWindow(String text, String popupMessage, exitText) {
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
                        child: Text("Abbrechen"),
                        onPressed: () => Navigator.pop(context)),
                  ],
                )));
  }

  Widget _buildLogoPictures(Size deviceSize) {
    return SizedBox(
      width: deviceSize.width,
      child: SvgPicture.asset("assets/images/logo/logo_text.svg",
          height: deviceSize.height * 0.05, width: deviceSize.width * 0.3),
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
