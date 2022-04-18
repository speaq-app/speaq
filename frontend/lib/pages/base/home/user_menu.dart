import 'package:flutter/material.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({Key? key}) : super(key: key);

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  final String langKey = "pages.base.home.";

  String userName = "@hhn";

  String name = "Informatics";

  String follower = "234";

  String following = "690";

  String image = "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenu(context),
              ],
            ),
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: const EdgeInsets.only(
          top: 24,
          bottom: 24,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(image),
              ),
              const SizedBox(height: 5),
              Text(
                name,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                userName,
                style: const TextStyle(fontSize: 15),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, 'follow'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Row(
                        children: [
                          Text(
                            following,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: Text(
                              'Following',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Text(
                              follower,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Text(
                            'Followers',
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

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
              Navigator.popAndPushNamed(context, "settings");
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
