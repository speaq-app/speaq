import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:frontend/utils/all_utils.dart';

import '../../widgets/speaq_settings_section.dart';

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
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: SpqAppBar(preferredSize: deviceSize, scrollController: ScrollController(), title: const Text(
        "Settings and Privacy",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),),
      body: Stack(children: [
        SettingsList(
          sections: [
            SpqSettingsSection(
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "@eric",
                  style: TextStyle(
                      color: spqBlack,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              tiles: [
                _buildSettingsTile("Account", "settAccount"),
                _buildSettingsTile("Privacy and safety", "settPrivSafety"),
                _buildSettingsTile("Notifications", "settNotific"),
                _buildSettingsTile("Content preferences", "settContentPref"),
              ],
            ),
            SpqSettingsSection(
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "General",
                  style: TextStyle(
                      color: spqBlack,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              tiles: [
                _buildSettingsTile("Display and Sound", "settDispSound"),
                _buildSettingsTile("Data usage", "settDataUsage"),
                _buildSettingsTile("Accessibility", "settAccess"),
                _buildSettingsTile("About speaq", "login"),
              ],
            ),
          ],
        ),
        Positioned(
          child: Align(alignment: Alignment.bottomCenter,child: _buildLogoPictures(deviceSize)), bottom: 20, height: deviceSize.height*0.1,
        )
      ]),
    );
  }

  Widget _buildLogoPictures(Size deviceSize) {
    return SizedBox(width: deviceSize.width,
      child: SvgPicture.asset("assets/images/logo/logo_text.svg", height: deviceSize.height*0.05, width: deviceSize.width*0.3),
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


