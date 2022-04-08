import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:frontend/utils/all_utils.dart';

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
      appBar: _buildAppBar(),
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
                _buildSettingsTile("Account", "login"),
                _buildSettingsTile("Privacy and safety", "login"),
                _buildSettingsTile("Notifications", "login"),
                _buildSettingsTile("Content preferences", "login"),
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
                _buildSettingsTile("Display and Sound", "login"),
                _buildSettingsTile("Data usage", "login"),
                _buildSettingsTile("Accessibility", "login"),
                _buildSettingsTile("About speaq", "login"),
              ],
            ),
          ],
        ),
        Positioned(
          child: Align(alignment: Alignment.bottomCenter,child: _buildLogoPicturres(deviceSize)), bottom: 20, height: deviceSize.height*0.1,
        )
      ]),
    );
  }

  Widget _buildLogoPicturres(Size deviceSize) {
    return SizedBox(width: deviceSize.width,
      child: Image(height: deviceSize.height*0.05, width: deviceSize.width*0.3,image: const AssetImage('assets/logo.png')),
    );
  }

  SettingsTile _buildSettingsTile(String text, String route) {
    return SettingsTile.navigation(
      trailing: Icon(Icons.adaptive.arrow_back),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      onPressed: (context) => Navigator.pushNamed(context, route),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "settings and privacy",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      centerTitle: true,
      leadingWidth: 80,
      actions: [
        TextButton(
          onPressed: () => log("done"),
          child: const Text("Done"),
        ),
      ],
    );
  }
}

class SpqSettingsSection extends AbstractSettingsSection {
  const SpqSettingsSection({
    required this.tiles,
    this.margin,
    this.title,
    Key? key,
  }) : super(key: key);

  final List<Widget> tiles;
  final EdgeInsetsDirectional? margin;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 24.0),
            child: title),
        Container(
          child: Column(
            children: tiles,
          ),
          decoration: const BoxDecoration(
              color: spqWhite,
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
        )
      ],
    );
  }
}
