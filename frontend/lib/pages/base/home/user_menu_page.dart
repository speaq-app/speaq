import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserMenuPage extends StatelessWidget {
  const UserMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenu(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
          padding: EdgeInsets.only(
        top: 24 + MediaQuery.of(context).padding.top,
        bottom: 24,
      ));

  Widget buildMenu(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Profile"),
            onTap: () {
              Navigator.popAndPushNamed(context, "profile");
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_2),
            title: const Text("QR-Code"),
            onTap: () {
              Navigator.popAndPushNamed(context, "pq-code");
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text("Bookmarks"),
            onTap: () {
              Navigator.popAndPushNamed(context, "bookmarks");
            },
          ),
          const Divider(
            color: Colors.black54,
            thickness: 0.75,
          ),
          ListTile(
            title: const Text("Settings and privacy"),
            onTap: () {
              Navigator.popAndPushNamed(context, "settingsPrivacy");
            },
          ),
          ListTile(
            title: const Text("Impressum"),
            onTap: () {
              Navigator.popAndPushNamed(context, "impressum");
            },
          ),
        ],
      );
}
