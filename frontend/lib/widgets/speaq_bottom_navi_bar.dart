import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';

class SpqButtonNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) switchPage;

  SpqButtonNavigationBar({
    Key? key,
    this.selectedIndex = 0,
    required this.switchPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.blue,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      iconSize: 30,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home, color: spqDarkGrey),
            activeIcon: Icon(Icons.home, color: spqPrimaryBlue),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.search, color: spqDarkGrey),
            activeIcon: Icon(Icons.search, color: spqPrimaryBlue),
            label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: spqDarkGrey),
            activeIcon: Icon(Icons.notifications, color: spqPrimaryBlue),
            label: 'Notification'),
        BottomNavigationBarItem(
            icon: Icon(Icons.message, color: spqDarkGrey),
            activeIcon: Icon(Icons.message, color: spqPrimaryBlue),
            label: 'Message'),
      ],
      currentIndex: selectedIndex,
      onTap: switchPage,
    );
  }
}
