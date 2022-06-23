import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_bottom_navi_bar.dart';

class BasePage extends StatefulWidget {
  final int userID;

  const BasePage({Key? key, required this.userID}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late ConnectionUtilSingleton connectionStatus;
  bool hasInternetConnection = true;
  late final List<Widget> _pages;
  late List<String> pageTitles;
  final ValueNotifier _selectedIndexNotifier = ValueNotifier<int>(0);
  final PageController _pageController = PageController();

  /// Checks the status and updates of the connection to the internet and initialize main pages.
  @override
  initState() {
    connectionStatus = ConnectionUtilSingleton.getInstance();
    connectionStatus.connectionChange.listen(_connectionChanged);

    super.initState();

    _pages = [
      HomePage(userID: widget.userID),
      const SearchPage(),
      const NotificationsPage(),
      const MessagesPage()
    ];
  }

  /// Sets [hasConnection] true, if there is a internet connection, otherwise a alert dailog pops up.
  void _connectionChanged(dynamic hasConnection) {
    setState(
      () {
        hasInternetConnection = hasConnection;
        if (!hasInternetConnection) {
          ConnectionUtilSingleton.noConnectionDialog(context);
        }
      },
    );
  }

  /// Makes the created pages swipeable.
  void _switchPage(int index) {
    _selectedIndexNotifier.value = index;
    _pageController.animateToPage(_selectedIndexNotifier.value,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
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
            // Custom buttom navigation bar for the pages.
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: _selectedIndexNotifier,
              builder: (context, value, widget) {
                return SpqButtonNavigationBar(
                  switchPage: _switchPage,
                  selectedIndex: value as int,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
