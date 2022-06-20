import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class AboutSpeaqSettingsPage extends StatefulWidget {
  const AboutSpeaqSettingsPage({Key? key}) : super(key: key);

  @override
  State<AboutSpeaqSettingsPage> createState() => _AboutSpeaqSettingsPageState();
}

class _AboutSpeaqSettingsPageState extends State<AboutSpeaqSettingsPage> {
  late AppLocalizations appLocale;
  late Size deviceSize;

  @override
  Widget build(BuildContext context) {
    appLocale = AppLocalizations.of(context)!;
    deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          title: Text(
            appLocale.aboutspeaq,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          preferredSize: deviceSize,
        ),
        body: buildListView(deviceSize),
      ),
    );
  }

  ListView buildListView(Size deviceSize) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: SpeaqBottomLogo(deviceSize: deviceSize * 2)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
          decoration: BoxDecoration(
              color: spqPrimaryBlue,
              border: Border.all(color: spqPrimaryBlue),
              borderRadius: BorderRadius.all(Radius.circular(26))),
          child: buildColumnForTeam(deviceSize),
        ),
      ],
    );
  }

  Column buildColumnForTeam(Size deviceSize) {
    return Column(
      children: [
        Text(appLocale.aboutus,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 32, color: spqWhite, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(appLocale.aboutustext,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: spqWhite)),
        ),
        Text(appLocale.ourteam,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 32, color: spqWhite, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: spqWhite,
              border: Border.all(color: spqWhite),
              borderRadius: BorderRadius.all(Radius.circular(26)),
            ),
            width: deviceSize.width,
            child: buildGridView(),
          ),
        ),
      ],
    );
  }

  GridView buildGridView() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        buildNumber("Sven Gatnar", "assets/images/developer_gatnar.jpg",
            appLocale.frontenddeveloper),
        buildNumber("Nosakhare Omoruyi", "assets/images/developer_omoruyi.jpg",
            appLocale.backendDeveloper),
        buildNumber("Daniel Holzwarth", "assets/images/developer_holzwarth.jpg",
            appLocale.backendDeveloper),
        buildNumber("David Löwe", "assets/images/developer_loewe.jpg",
            appLocale.frontenddeveloper),
        buildNumber(
            "Hendrik Schlehlein",
            "assets/images/developer_schlehlein.jpg",
            appLocale.backendDeveloper),
        buildNumber("Eric Eisemann", "assets/images/developer_eisemann.jpg",
            appLocale.frontenddeveloper),
      ],
    );
  }

  Widget buildImage(String jpgString) {
    return CircleAvatar(
      backgroundImage: AssetImage(jpgString),
      radius: deviceSize.width / 8,
    );
  }

  Widget buildNumber(String name, String jpgString, String role) {
    return Container(
      padding: EdgeInsets.all(16),
      child: GridTile(
        header: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        child: Center(child: buildImage(jpgString)),
        footer: Text(role,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
