import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsPage> createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
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
            appLocale.notifications,
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
                  SpqSwitchSettingsTile(tileText: appLocale.doNotDisturb, value: valuePrivateSwitch),
                  //Methode für SettingsTile
                  SpqNavigationSettingsTile(text: appLocale.receiveNotifications),
                  SpqNavigationSettingsTile(text: appLocale.notificationSound),
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
