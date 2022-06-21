import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
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
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          title: Text(
            appLocale.privacyandsafety,
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
                    SettingsTile.switchTile(
                      title: Text(appLocale.privateAccount,
                          style: const TextStyle(fontSize: 15)),
                      initialValue: valuePrivateSwitch,
                      onToggle: (value) {
                        setState(
                          () {
                            valuePrivateSwitch = value;
                          },
                        );
                      },
                    ),
                    // Clear search history.
                    _buildPopUpWindow(
                        appLocale.deletesearchhistory,
                        appLocale.askdeletesearchhistory,
                        appLocale.delete,
                        appLocale),
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

  /// Returns a [SettingsTile] an Element for the Listview.
  SettingsTile _buildPopUpWindow(String text, String popupMessage,
      String exitText, AppLocalizations appLocale) {
    return SettingsTile.navigation(
      trailing: Icon(Icons.adaptive.arrow_forward),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      onPressed: (context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(popupMessage),
          actions: [
            TextButton(
                child: Text(exitText), onPressed: () => Navigator.pop(context)),
            TextButton(
                child: Text(appLocale.cancel),
                onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
