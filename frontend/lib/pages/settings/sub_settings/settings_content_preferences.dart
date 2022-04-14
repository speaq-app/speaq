import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../widgets/speaq_appbar.dart';
import '../../../widgets/speaq_settings_section.dart';

class ContentPrefSettingsPage extends StatefulWidget {
  const ContentPrefSettingsPage({Key? key}) : super(key: key);

  @override
  State<ContentPrefSettingsPage> createState() => _ContentPrefSettingsPageState();
}

class _ContentPrefSettingsPageState extends State<ContentPrefSettingsPage> {
  bool valuePrivateSwitch = false;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SpqAppBar(
        preferredSize: deviceSize,
        scrollController: ScrollController(),
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
                //Sprachauswahl
                _buildSettingsTile("Sprache", "login"),
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

  SettingsTile _buildSettingsTile(String text, String route) {
    return SettingsTile.navigation(
      trailing: Icon(Icons.adaptive.arrow_forward),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      onPressed: (context) => Navigator.pushNamed(context, route),
    );
  }

  Widget _buildLogoPictures(Size deviceSize) {
    return SizedBox(
      width: deviceSize.width,
      child: SvgPicture.asset("assets/images/logo/logo_text.svg",
          height: deviceSize.height * 0.05, width: deviceSize.width * 0.3),
    );
  }
}
