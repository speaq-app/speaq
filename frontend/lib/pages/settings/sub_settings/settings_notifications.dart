import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:settings_ui/settings_ui.dart';

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
        body: Stack(
          children: [
            SettingsList(
              sections: [
                SpqSettingsSection(
                  title: const Padding(
                    padding: EdgeInsets.all(25.0),
                  ),
                  tiles: [
                    // Private account SwitchTile.
                    buildSettingsSwitchTile(appLocale.notdisturb),
                    // Method for SettingsTile.
                    _buildSettingsTile(appLocale.receivenotifications, "login"),
                    _buildSettingsTile(appLocale.notificationSound, "login"),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              height: deviceSize.height * 0.1,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SpeaqBottomLogo(deviceSize: deviceSize)),
            )
          ],
        ),
      ),
    );
  }

  /// Create and returns [SettingsTile] that will added to [SpqSettingsSection].
  SettingsTile buildSettingsSwitchTile(String text) {
    return SettingsTile.switchTile(
      title: Text(text, style: const TextStyle(fontSize: 15)),
      initialValue: valuePrivateSwitch,
      onToggle: (value) {
        setState(
          () {
            valuePrivateSwitch = value;
          },
        );
      },
    );
  }

  /// Creates an returns one element for [SettingsTile].
  SettingsTile _buildSettingsTile(String text, String route) {
    return SettingsTile.navigation(
      trailing: Icon(Icons.adaptive.arrow_forward),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      onPressed: (context) => Navigator.pushNamed(context, route),
    );
  }
}
