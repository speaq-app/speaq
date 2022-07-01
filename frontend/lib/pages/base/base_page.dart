import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_bottom_navi_bar.dart';

class BasePage extends StatefulWidget {
  final int initialPage;

  const BasePage({Key? key, this.initialPage = 0}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late ConnectionUtilSingleton connectionStatus;
  bool hasInternetConnection = true;

  /// Checks the active internet connection and invokes alert dialog if not.
  void _connectionChanged(dynamic hasConnection) {
    setState(() {
      hasInternetConnection = hasConnection;
      if (!hasInternetConnection) {
        ConnectionUtilSingleton.noConnectionDialog(context);
      }
    });
  }

  late final List<Widget> _pages;
  late List<String> pageTitles;
  late final ValueNotifier _selectedIndexNotifier = ValueNotifier<int>(widget.initialPage);
  late final PageController _pageController = PageController(initialPage: widget.initialPage);

  /// Makes the main pages swipe-able.
  void _switchPage(int index) {
    _selectedIndexNotifier.value = index;
    _pageController.animateToPage(_selectedIndexNotifier.value,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  /// Inits and invokes the four main pages after login. Listens to stream and checks updates of the internet connection.
  @override
  initState() {
    connectionStatus = ConnectionUtilSingleton.getInstance();
    connectionStatus.connectionChange.listen(_connectionChanged);

    super.initState();

    _pages = [
      const HomePage(),
      const SearchPage(),
      const NotificationsPage(),
      const MessagesPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndexNotifier.value != 0) {
          _switchPage(0);
        }
        return false;
      },
      child: Container(
        color: spqBackgroundGrey,
        child: SafeArea(
          child: Scaffold(
            body: PageView(
              onPageChanged: (index) {
                _selectedIndexNotifier.value = index;
              },
              controller: _pageController,
              children: _pages,
            ),
            // Custom bottom navigation bar for the pages.
            bottomNavigationBar: ValueListenableBuilder(
                valueListenable: _selectedIndexNotifier,
                builder: (context, value, widget) {
                  return SpqButtonNavigationBar(
                    switchPage: _switchPage,
                    selectedIndex: value as int,
                  );
                }),
          ),
        ),
      ),
    );
  }
}
