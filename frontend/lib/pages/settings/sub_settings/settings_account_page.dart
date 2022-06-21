import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_settings_section.dart';
import 'package:settings_ui/settings_ui.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          title: Text(
            appLocale.account,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          preferredSize: deviceSize,
        ),
        body: Stack(children: [
          SettingsList(
            sections: [
              SpqSettingsSection(
                tiles: [
                  const SizedBox(
                    height: 20,
                  ),
                  _buildSettingsTile(appLocale.accinformation, "login"),
                  _buildSettingsTile(appLocale.changepassword, "login"),
                  //Account löschen
                  _buildPopUpWindow(appLocale.deleteaccount, appLocale.askdeleteaccount, appLocale.delete),
                  //Account abmelden
                  _buildPopUpWindow(appLocale.acclogout, appLocale.asklogoutaccount, appLocale.logout),
                ],
              ),
            ],
          ),
          //Logo
          Positioned(
            child: Align(alignment: Alignment.bottomCenter, child: _buildLogoPictures(deviceSize)),
            bottom: 20,
            height: deviceSize.height * 0.1,
          )
        ]),
      ),
    );
  }

  //Pop-up-Fenster
  SettingsTile _buildPopUpWindow(String text, String popupMessage, String exitText) {
    return SettingsTile.navigation(
      trailing: Icon(Icons.adaptive.arrow_forward),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      onPressed: (context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(popupMessage),
          actions: [
            TextButton(child: Text(exitText), onPressed: () => Navigator.pop(context)),
            TextButton(child: Text(appLocale.cancel), onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPictures(Size deviceSize) {
    return SizedBox(
      width: deviceSize.width,
      child: SvgPicture.asset("assets/images/logo/speaq_text_logo.svg",
          height: deviceSize.height * 0.05, width: deviceSize.width * 0.3
      ),
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
