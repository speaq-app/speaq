import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/pages/base/home/user_menu.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_post_container.dart';
import 'package:frontend/widgets/spq_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _postMessage = "Welcome to our presentation, how are you ? Just did something lit here!!! yeah #speaq #beer";
  final String _name = "Informatics";
  final String _username = "@hhn";
  final String _postImage = "https://images.ctfassets.net/l3l0sjr15nav/dGLEVnJ6E3IuJE4NNFX4z/418da4b5783fa29d4abcabb7c37f71b7/2020-06-11_-_Wie_man_schnell_ein_GIF_erstellt.gif";
  final String langKey = "pages.base.home.";
  final String _postImage2 = "https://www.architekten-online.com/media/03_-hhn-hochschule-heilbronn.jpg";
  String profilePicture = "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";
  String spqImage = "assets/images/logo/speaq_logo.svg";

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
              PostContainer(
                name: _name,
                username: _username,
                postMessage: _postMessage,
                postImage: Image.network(_postImage),
              ),
              const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
              PostContainer(
                name: _name,
                username: _username,
                postMessage: _postMessage,
                postImage: Image.network(_postImage2),
              ),
              const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
              PostContainer(
                name: _name,
                username: _username,
                postMessage: _postMessage,
              ),const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
              PostContainer(
                name: _name,
                username: _username,
                postMessage: _postMessage,
                postImage: Image.network(_postImage),
              ),const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
              PostContainer(
                name: _name,
                username: _username,
                postMessage: _postMessage,
                postImage: Image.network(_postImage2),
              ),const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
              PostContainer(
                name: _name,
                username: _username,
                postMessage: _postMessage,
                postImage: Image.network(_postImage),
              ),const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
              PostContainer(
                name: _name,
                username: _username,
                postMessage: _postMessage,
                postImage: Image.network(_postImage2),
              ),const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
              PostContainer(
                name: _name,
                username: _username,
                postMessage: _postMessage,
                postImage: Image.network(_postImage),
              ),
            ],
          ),
        ),
        floatingActionButton: SpqFloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'new_post'),
          heroTag: 'post',
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ),
      ),
    );
  }
}
