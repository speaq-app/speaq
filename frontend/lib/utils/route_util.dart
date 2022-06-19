import 'package:flutter/material.dart';
import 'package:frontend/api/model/user.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/pages/settings/sub_settings/settings_about_speaq.dart';

import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "main":
        return PageTransition(
          child: MainApp(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "base":
        return PageTransition(
          child: const BasePage(),
          type: PageTransitionType.bottomToTop,
          alignment: Alignment.center,
        );
      case "login":
        return PageTransition(
          child: const LoginPage(),
          type: PageTransitionType.topToBottom,
          alignment: Alignment.center,
        );
      case "register":
        return PageTransition(
          child: const RegisterPage(),
          type: PageTransitionType.rightToLeftWithFade,
          alignment: Alignment.center,
        );
      case "settings":
        return PageTransition(
          child: const SettingsPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "profile":
        return PageTransition(
          child: const ProfilePage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "home":
        return PageTransition(
          child: const HomePage(),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 400),
          alignment: Alignment.center,
        );
      case "messages":
        return PageTransition(
          child: const MessagesPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "notifications":
        return PageTransition(
          child: const NotificationsPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "search":
        return PageTransition(
          child: const SearchPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      //Settings
      case "settingsPrivacy":
        return PageTransition(
          child: const SettingsAndPrivacyPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "settAccount":
        return PageTransition(
          child: const AccountSettingsPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "settPrivSafety":
        return PageTransition(
          child: const PrivacySafetySettingsPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "settNotific":
        return PageTransition(
          child: const NotificationsSettingsPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "settContentPref":
        return PageTransition(
          child: const ContentPrefSettingsPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "settDispSound":
        return PageTransition(
          child: const DisplaySoundSettingsPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "settAboutSpeaq":
        return PageTransition(
          child: const AboutSpeaqSettingsPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "bookmarks":
        return PageTransition(
          child: const BookmarksPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "impressum":
        return PageTransition(
          child: const ImpressumPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "new_post":
        return PageTransition(
          child: const NewPostPage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "qr_code":
        return PageTransition(
          child: const QrCodePage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "edit_profile":
        return PageTransition(
          child: const EditProfilePage(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case "follow":
        User user = args as User;
        return PageTransition(
            child: FollowPage(
              user: user,
            ),
            type: PageTransitionType.fade);
      default:
        return _errorRoute();
    }
  }

  static _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
            appBar: AppBar(title: const Text("ERROR")),
            body: const Center(child: Text("ERROR")));
      },
    );
  }
}
