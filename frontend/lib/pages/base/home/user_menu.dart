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
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                    'https://dieschneidersgmbh.de/wp-content/uploads/2020/11/Mercedes-AMG-GTR-fahren-dieschneiders-1-1.jpg'),
              ),
              const SizedBox(height: 5),
              const Text(
                'David',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Text(
                '@david',
                style: TextStyle(fontSize: 15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        '234',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Text(
                          'Following',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            '690',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildMenu(BuildContext context) => Container();
}
