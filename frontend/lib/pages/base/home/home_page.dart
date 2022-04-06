import 'package:flutter/material.dart';
import 'package:frontend/pages/base/home/user_menu.dart';
import 'package:frontend/utils/all_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 4.0,
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://dieschneidersgmbh.de/wp-content/uploads/2020/11/Mercedes-AMG-GTR-fahren-dieschneiders-1-1.jpg'),
                  ));
            })),
        drawer: UserMenu(),
      );
}
