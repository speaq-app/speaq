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
  final numbers = List.generate(100, (index) => '$index');

  @override
  Widget build(BuildContext context) {
    appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;

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
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: SpeaqBottomLogo(deviceSize: deviceSize * 2)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
              decoration: BoxDecoration(
                  color: spqPrimaryBlue,
                  border: Border.all(color: spqPrimaryBlue),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Text("About us",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32, color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                        "Du willst der Welt deine Meinungen, Gedanken und News mitteilen - mit all deinen Gefühlen und Rhetoriken - ganz persönlich? \nViele Kunden wünschen sich eine persönlichere Form der Online-Kommunikation, wie sie heute noch nicht geboten wird. Und hier kommt Speaq zum Einsatz! Wir bieten mit Speaq eine innovative Kommunikationsplattform, die Abwechslung von bekannten Plattformen wie Twitter und Facebook bietet.",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  Container(
                    width: deviceSize.width,
                    child: Column(
                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text("Our team",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 32, color: spqPrimaryBlue)),
                        ),


                  Container(
                    child: GridView.count(
                            shrinkWrap: true,
                            // Create a grid with 2 columns. If you change the scrollDirection to
                            // horizontal, this would produce 2 rows.
                            crossAxisCount: 2,
                            // Generate 100 Widgets that display their index in the List
                            children: [
                              buildImage("assets/images/developer_gatnar.jpg"),
                              buildImage("assets/images/developer_omoruyi.jpg"),
                              buildImage("assets/images/developer_holzwarth.jpg"),
                              buildImage("assets/images/developer_loewe.jpg"),
                              buildImage("assets/images/developer_schlehlein.jpg"),
                              buildImage("assets/images/developer_eisemann.jpg"),
                              buildNumber("fdsg")
                            ],
                          ),
                        ),
                        

                      ],
                    ),
                    padding: EdgeInsets.symmetric(),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Image buildImage(String jpgString) {
    return Image.asset(
      jpgString,
      width: 30,
      height: 30,
      fit: BoxFit.cover,
    );
  }
  

  Widget buildNumber(String number) => Container(
        padding: EdgeInsets.all(16),
        color: Colors.orange,
        child: GridTile(
          header: Text(
            'Header $number',
            textAlign: TextAlign.center,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
              textAlign: TextAlign.center,
            ),
          ),
          footer: Text(
            'Footer $number',
            textAlign: TextAlign.center,
          ),
        ),
      );
}
