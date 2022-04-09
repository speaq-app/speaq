import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/speaq_styles.dart';

class SPQButtonNavigationBar extends StatefulWidget {
  const SPQButtonNavigationBar({Key? key}) : super(key: key);

  @override
  State<SPQButtonNavigationBar> createState() => _SPQButtonNavigationBarState();
}

class _SPQButtonNavigationBarState extends State<SPQButtonNavigationBar> {
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
    return Scaffold(
      body: PageView(
        children: _pages,
        onPageChanged: (index){
          setState(() {
            _selectedIndex=index;

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
          BottomNavigationBarItem(icon: Icon(Icons.home, color: spqDarkGrey), activeIcon: Icon(Icons.home, color: spqPrimaryBlue), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search, color: spqDarkGrey), activeIcon: Icon(Icons.search, color: spqPrimaryBlue), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications, color: spqDarkGrey), activeIcon: Icon(Icons.notifications, color: spqPrimaryBlue), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.message, color: spqDarkGrey), activeIcon: Icon(Icons.message, color: spqPrimaryBlue), label: 'Message'),
        ],
        currentIndex: _selectedIndex,
        onTap: _switchPage,
      ),
    );
  }
}
