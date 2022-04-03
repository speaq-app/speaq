import 'package:flutter/material.dart';
import 'package:frontend/pages/base/home/user_menu.dart';
import 'package:frontend/utils/all_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showBackToTopButton = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Center(
              child: InkWell(
                onTap: () {
                  _scrollController.animateTo(0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.linear);
                },
                child: Image.asset(
                  'assets/images/logo/logo.speaq.png',
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 4.0,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                color: Colors.blue,
                iconSize: 25,
                onPressed: () => {},
              )
            ],
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://dieschneidersgmbh.de/wp-content/uploads/2020/11/Mercedes-AMG-GTR-fahren-dieschneiders-1-1.jpg'),
                  ));
            })),
        drawer: const UserMenu(),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // add a bunch of containers to make the screen longer
              Container(
                height: 600,
                color: Colors.amber,
              ),
              Container(
                height: 600,
                color: Colors.blue[100],
              ),
              Container(
                height: 600,
                color: Colors.red[200],
              ),
              Container(
                height: 600,
                color: Colors.orange,
              ),
              Container(
                height: 600,
                color: Colors.yellow,
              ),
              Container(
                height: 1200,
                color: Colors.lightGreen,
              ),
            ],
          ),
        ),
      );
}