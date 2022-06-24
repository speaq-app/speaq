import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class PrivacySafetySettingsPage extends StatefulWidget {
  const PrivacySafetySettingsPage({Key? key}) : super(key: key);

  @override
  State<PrivacySafetySettingsPage> createState() => _PrivacySafetySettingsPageState();
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
            appLocale.privacyAndSafety,
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
                  //Privates Konto SwitchTile
                  SpqSwitchSettingsTile(tileText: appLocale.privateAccount, value: valuePrivateSwitch),
                  //Suchverlauf löschen
                  SpqPopUpSettingsTile(
                    tileText: appLocale.deleteSearchHistory,
                    actionButtonText: appLocale.delete,
                    popupMessage: appLocale.askDeleteSearchHistory,
                    actionButtonColor: spqErrorRed,
                  ),
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
}
