import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({Key? key}) : super(key: key);

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
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_2),
            title: const Text("QR-Code"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text("Bookmarks"),
            onTap: () {},
          ),
          const Divider(
            color: Colors.black54,
            thickness: 0.75,
          ),
          ListTile(
            title: const Text("Settings and privacy"),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Impressum"),
            onTap: () {},
          ),
        ],
      );
}
