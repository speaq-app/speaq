import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/pages/base/home/user_menu.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/spq_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String langKey = "pages.base.home.";

  String profilePicture =
      "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";
  String spqImage = "assets/images/logo/logo_speaq.svg";

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

    return Container(
      color: spqBackgroundGrey,
      child: Scaffold(
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
          preferredSize: deviceSize,
        ),
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
        floatingActionButton: SpqFloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'new_post'),
          heroTag: 'post',
          child: SvgPicture.asset("assets/images/logo/logo_text.svg"),
        ),
      ),
    );
  }
}
