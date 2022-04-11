import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_bottom_navi_bar.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  /*Singleton, für die Überprüfung der Internetverbindung zuständig ist*/
  late ConnectionUtilSingleton connectionStatus;
  bool hasInternetConnection = true;

  /*Alle Seiten, direkt nach dem Login aufgerufen werden können
  * und in der BottomNavigationBar vertreten sind*/

  /*Die Variable wird initialisiert und hört dem Stream, welcher updates über die Internetverbindung gibt, zu*/
  @override
  initState() {
    connectionStatus = ConnectionUtilSingleton.getInstance();
    connectionStatus.connectionChange.listen(_connectionChanged);

    super.initState();
  }

  /*Methode setzt die boolean Variable, welche angibt, ob eine aktive Verbindung zum Internet besteht
  * und ruft bei keine Internetverbindung einen Alert-Dialog auf*/
  void _connectionChanged(dynamic hasConnection) {
    setState(() {
      hasInternetConnection = hasConnection;
      if (!hasInternetConnection) {
        ConnectionUtilSingleton.noConnectionDialog(context);
      }
    });
  }

  final List<Widget> _pages = const [HomePage(), SearchPage(), NotificationsPage(), MessagesPage()];
  late List<String> pageTitles;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _switchPage(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(_selectedIndex, duration: const Duration(milliseconds: 200), curve: Curves.linear);
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          children: _pages,
          onPageChanged: (index){
            setState(() {
              _selectedIndex=index;
            });
          },
          controller: _pageController,
        ),
        bottomNavigationBar: SpqButtonNavigationBar(switchPage: _switchPage, selectedIndex: _selectedIndex,),
      ),
    );
  }
}
