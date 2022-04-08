import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';

import 'package:frontend/utils/all_utils.dart';

import 'widgets/all_widgets.dart';

void main() {
  runApp(const Speaq());
}

class Speaq extends StatelessWidget {
  const Speaq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speaq',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(foregroundColor: spqBlack, backgroundColor: spqWhite),
          scaffoldBackgroundColor: spqWhite,
          backgroundColor: spqBackgroundGrey,
          bottomAppBarColor: spqWhite,

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: spqWhite, selectedItemColor: spqPrimaryBlue, unselectedItemColor: spqDarkGrey),
          dialogBackgroundColor: spqWhite,
          primaryColor: spqPrimaryBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          errorColor: spqErrorRed,
          shadowColor: spqLightGreyTranslucent,
          //MOCKUP-SCHRIFTART (POPPINS) ALS STANDARDFONT
          textTheme: spqTextTheme),
      initialRoute: 'main',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: verifyIDToken(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const LoginPage();
        } else if (snapshot.hasData) {
          if (snapshot.data!) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        } else {
          return SpqLoadingWidget(MediaQuery.of(context).size.shortestSide * 0.25);
        }
      },
    );
  }
}

Future<bool> verifyIDToken() {
  return Future.delayed(Duration(seconds: 5), () => false);
}

class SPQButtonNavigationBar extends StatefulWidget {
  SPQButtonNavigationBar({Key? key}) : super(key: key);

  @override
  State<SPQButtonNavigationBar> createState() => _SPQButtonNavigationBarState();
}

class _SPQButtonNavigationBarState extends State<SPQButtonNavigationBar> {
  int _selectedItem = 0;
  var _pages = [HomePage(), SearchPage(), NotificationsPage(), MessagesPage()];
  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placeholder'),
      ),
      body: PageView(
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedItem = index;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notification"),
          BottomNavigationBarItem(
              icon: Icon(Icons.message), label: "Message")
        ],
        currentIndex: _selectedItem,
        onTap: (index) {
          setState(() {
            _selectedItem = index;
            _pageController.animateToPage(_selectedItem,
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          });
        },
      ),
    );
  }
}
