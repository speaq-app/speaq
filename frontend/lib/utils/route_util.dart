import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
/*
    final Map<String, dynamic> args;
*/

    switch (settings.name) {
      case "main":
        return PageTransition(child: const MainApp(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "base":
        return PageTransition(child: const BasePage(), type: PageTransitionType.topToBottom, alignment: Alignment.center);
      case "login":
        return PageTransition(child: const LoginPage(), type: PageTransitionType.topToBottom, alignment: Alignment.center);
      case "register":
        return PageTransition(child: const RegisterPage(), type: PageTransitionType.rightToLeftWithFade, alignment: Alignment.center);
      case "settings":
        return PageTransition(child: const SettingsPage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "profile":
        return PageTransition(child: const ProfilePage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "home":
        return PageTransition(child: const HomePage(), type: PageTransitionType.bottomToTop, duration: const Duration(milliseconds: 400), alignment: Alignment.center);
      case "messages":
        return PageTransition(child: const MessagesPage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "notifications":
        return PageTransition(child: const NotificationsPage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "search":
        return PageTransition(child: SearchPage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "settingsPrivacy":
        return PageTransition(child: SettingsAndPrivacyPage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "bookmarks":
        return PageTransition(child: BookmarksPage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "impressum":
        return PageTransition(child: ImpressumPage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "qr_code":
        return PageTransition(child: QrCodePage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "edit_profile":
        return PageTransition(child: const EditProfilePage(), type: PageTransitionType.fade, alignment: Alignment.center);
      case "follow":
/*
        args = settings.arguments as Map<String, dynamic>;
        String username = args["username"];
*/
        return PageTransition(child: const FollowPage(username: "username"), type: PageTransitionType.fade);
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
