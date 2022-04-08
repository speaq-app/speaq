import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/pages/base/home/user_menu.dart';
import 'package:frontend/widgets/speaq_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String profilePicture =
      "https://dieschneidersgmbh.de/wp-content/uploads/2020/11/Mercedes-AMG-GTR-fahren-dieschneiders-1-1.jpg";
  String spqImage = "lib/assets/images/logo/logo_speaq.svg";

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
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SpqAppBar(
        actionList: [
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
              icon: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profilePicture),
              ));
        }),
        title: Center(
          child: InkWell(
            onTap: () {
              _scrollController.animateTo(0,
                  duration: const Duration(seconds: 1), curve: Curves.linear);
            },
            child: SvgPicture.asset(
              spqImage,
              height: deviceSize.height * 0.055,
              alignment: Alignment.center,
            ),
          ),
        ),
        scrollController: _scrollController,
        preferredSize: Size.fromHeight(deviceSize.height * 0.075),
      ),
      drawer: UserMenu(),
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
}
