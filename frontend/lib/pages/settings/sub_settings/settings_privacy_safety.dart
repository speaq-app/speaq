import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
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
  late AppLocalizations appLocale;

  @override
  Widget build(BuildContext context) {
    appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          title: Text(
            appLocale.privacyandsafety,
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
                  SettingsTile.switchTile(
                    title:
                        Text(appLocale.privateAccount, style: TextStyle(fontSize: 15)),
                    initialValue: valuePrivateSwitch,
                    onToggle: (value) {
                      setState(() {
                        valuePrivateSwitch = value;
                      });
                    },
                  ),
                  //Suchverlauf löschen
                  _buildPopUpWindow(
                      appLocale.deletesearchhistory,
                      appLocale.askdeletesearchhistory,
                      appLocale.delete),
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
                        child: Text(appLocale.cancel),
                        onPressed: () => Navigator.pop(context)),
                  ],
                )));
  }
}
