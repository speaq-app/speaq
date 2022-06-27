import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class AboutSpeaqSettingsPage extends StatefulWidget {
  const AboutSpeaqSettingsPage({Key? key}) : super(key: key);

  @override
  State<AboutSpeaqSettingsPage> createState() => _AboutSpeaqSettingsPageState();
}

class _AboutSpeaqSettingsPageState extends State<AboutSpeaqSettingsPage> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          title: Text(
            appLocale.aboutSpeaq,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          preferredSize: deviceSize,
        ),
        body: buildListView(deviceSize, appLocale),
      ),
    );
  }

  ListView buildListView(Size deviceSize, AppLocalizations appLocale) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: SpeaqBottomLogo(deviceSize: deviceSize * 2)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
          decoration: BoxDecoration(
              color: spqPrimaryBlue,
              border: Border.all(color: spqPrimaryBlue),
              borderRadius: const BorderRadius.all(Radius.circular(26))),
          child: buildDescriptionForTeam(appLocale, deviceSize),
        ),
      ],
    );
  }

  /// The description that shows the [Text] of the developer team.
  Column buildDescriptionForTeam(AppLocalizations appLocale, Size deviceSize) {
    return Column(
      children: [
        Text(appLocale.aboutUs, textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, color: spqWhite, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(appLocale.aboutUsText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: spqWhite)),
        ),
        Text(appLocale.ourTeam, textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, color: spqWhite, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: spqWhite,
              border: Border.all(color: spqWhite),
              borderRadius: const BorderRadius.all(Radius.circular(26)),
            ),
            width: deviceSize.width,
            child: buildGridView(appLocale, deviceSize),
          ),
        ),
      ],
    );
  }

  /// Creates and returns a [Gridview] with two columns and any number of rows.
  GridView buildGridView(AppLocalizations appLocale, Size deviceSize) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        buildDeveloperProfile(
            "Sven Gatnar",
            "assets/images/developer_gatnar.jpg",
            appLocale.frontendDeveloper,
            deviceSize),
        buildDeveloperProfile(
            "Nosakhare Omoruyi",
            "assets/images/developer_omoruyi.jpg",
            appLocale.backendDeveloper,
            deviceSize),
        buildDeveloperProfile(
            "Daniel Holzwarth",
            "assets/images/developer_holzwarth.jpg",
            appLocale.backendDeveloper,
            deviceSize),
        buildDeveloperProfile("David Löwe", "assets/images/developer_loewe.jpg",
            appLocale.frontendDeveloper, deviceSize),
        buildDeveloperProfile(
            "Hendrik Schlehlein",
            "assets/images/developer_schlehlein.jpg",
            appLocale.backendDeveloper,
            deviceSize),
        buildDeveloperProfile(
            "Eric Eisemann",
            "assets/images/developer_eisemann.jpg",
            appLocale.frontendDeveloper,
            deviceSize),
      ],
    );
  }

  /// Returns a [Container] for one developer profile and later for [buildGridView].
  Widget buildDeveloperProfile(
      String name, String jpgString, String role, Size deviceSize) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridTile(
        header: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        footer: Text(role, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold),),
        child: Center(child: buildImage(jpgString, deviceSize),),
      ),
    );
  }

  Widget buildImage(String jpgString, Size deviceSize) {
    return CircleAvatar(
      backgroundImage: AssetImage(jpgString),
      radius: deviceSize.width / 8,
    );
  }
}
