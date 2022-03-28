import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:page_transition/page_transition.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name) {
      case "main":
        return PageTransition(child: MainApp(), type: PageTransitionType.fade);
      case "login":
        return PageTransition(child: LoginPage(), type: PageTransitionType.fade);
      case "register":
        return PageTransition(child: RegisterPage(), type: PageTransitionType.fade);
      case "settings":
        return PageTransition(child: SettingsPage(), type: PageTransitionType.fade);
      case "profile":
        return PageTransition(child: ProfilePage(), type: PageTransitionType.fade);
      case "home":
        return PageTransition(child: HomePage(), type: PageTransitionType.fade);
      case "messages":
        return PageTransition(child: MessagesPage(), type: PageTransitionType.fade);
      case "notifications":
        return PageTransition(child: NotificationsPage(), type: PageTransitionType.fade);
      case "search":
        return PageTransition(child: SearchPage(), type: PageTransitionType.fade);
      default:
        return _errorRoute();
    }
  }

  static _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: Text("ERROR")),
          body: Center(
              child: Text("ERROR")
          )
      );
    },);
  }
}