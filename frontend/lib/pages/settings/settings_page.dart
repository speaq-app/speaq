import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  initState() {
    super.initState();
  }

  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          title: Text(
            appLocale.settingsandprivacy,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Stack(
          children: [
            SettingsList(
              sections: [
                SpqSettingsSection(
                  title: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "@eric",
                      style: TextStyle(color: spqBlack, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  tiles: [
                    _buildSettingsTile(appLocale.account, "settAccount"),
                    _buildSettingsTile(appLocale.privacyandsafety, "settPrivSafety"),
                    _buildSettingsTile(appLocale.notifications, "settNotific"),
                    _buildSettingsTile(appLocale.contentpreferences, "settContentPref"),
                  ],
                ),
                SpqSettingsSection(
                  title: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      appLocale.general,
                      style: TextStyle(color: spqBlack, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  tiles: [
                    _buildSettingsTile(appLocale.displayandsound, "settDispSound"),
                    _buildSettingsTile(appLocale.aboutspeaq, "settAboutSpeaq"),
                  ],
                ),
              ],
            ),
            Positioned(
              child: Align(alignment: Alignment.bottomCenter, child: _buildLogoPictures(deviceSize)),
              bottom: 20,
              height: deviceSize.height * 0.1,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPictures(Size deviceSize) {
    return SizedBox(
      width: deviceSize.width,
      child: SvgPicture.asset("assets/images/logo/speaq_text_logo.svg", height: deviceSize.height * 0.05, width: deviceSize.width * 0.3),
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
