import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/utils/speaq_styles.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_bottom_navi_bar.dart';
import 'package:frontend/widgets/speaq_post_container.dart';
import 'package:frontend/widgets/speaq_text_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollow = false;
  final String langKey = "pages.profile.";
  final String _postMessage = "Welcome to our presentation, how are you ? Just did something lit here!!! yeah #speaq #beer";
  final String _link = "hs-heilbronn.de";
  final String _name = "Informatics";
  final String _username = "@hhn";
  final String _bio = "I like Hochschule Heilbronn";
  final String _joined = "Joined August 2022";
  final String _follower = "117k Follower";
  final String _following = "69 Follower";
  final String _editProfile = "Edit Profile";
  final String _follow = "Follow";
  final String _unfollow = "Unfollow";

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          title: Text(
            _username,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            _buildProfileCover(deviceSize, context),
            _buildProfileStack(deviceSize),
            _buildTabs(deviceSize)
          ],
        ),
        bottomNavigationBar: SpqButtonNavigationBar(
          switchPage: (index) {
            Navigator.pushNamed(context, "base");
          },
          selectedIndex: 0,
        ),
      ),
    );
  }

  Widget _buildProfilePicture(Size deviceSize) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              _buildProfileImageFullScreen(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ),
      ),
      child: const Hero(
        tag: 'myImage',
        child: CircleAvatar(
          radius: 43,
          backgroundImage: NetworkImage(
              'https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg'),
        ),
      ),
    );
  }

  Widget _buildProfileImageFullScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _username,
          style: const TextStyle(color: spqBlack),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: spqBlack,
        ),
        backgroundColor: spqWhite,
      ),
      body: Container(
        color: spqWhite,
        child: Center(
          child: Hero(
            tag: 'myImage',
            child: Image.network(
                "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg"),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCover(Size deviceSize, BuildContext context) {
    return Container(
      height: deviceSize.height * 0.225,
      width: deviceSize.width,
      decoration: const BoxDecoration(
        color: spqPrimaryBlue,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              'https://www.jobvector.de/karriere-ratgeber/wp-content/uploads/2021/05/it-security360x240.jpg'),
        ),
      ),
    );
  }

  /*SizedBox _buildHeader(Size deviceSize, BuildContext context) => SizedBox(
        width: deviceSize.width,
        height: deviceSize.height * 0.50,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              child: _buildCover(deviceSize),
            ),
            Positioned(
              top: deviceSize.height * 0.13,
              height: deviceSize.height * 0.17,
              width: deviceSize.width,
              child: _buildPictureEditProfile(deviceSize),
            ),
            Positioned(
              top: 210,
              child: _buildProfileInformation(context, deviceSize),
            ),
          ],
        ),
      );*/

/*  Widget _buildCover(Size deviceSize) {
    return Container(
      height: deviceSize.height * 0.225,
      width: deviceSize.width,
      decoration: const BoxDecoration(
        color: spqPrimaryBlue,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              'https://www.jobvector.de/karriere-ratgeber/wp-content/uploads/2021/05/it-security360x240.jpg'),
        ),
      ),
    );
  }*/

  Widget _buildProfileStack(Size deviceSize) {
    return Container(
      transform: Matrix4.translationValues(0, -40, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildProfilePicture(deviceSize),
              Container(
                width: deviceSize.width * 0.31,
                height: deviceSize.height * 0.05,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SpqTextbutton(
                  onPressed: () => Navigator.pushNamed(context, 'edit_profile'),
                  name: _editProfile,
                  style: const TextStyle(color: spqPrimaryBlue),
                ),
              ),
/*        Padding(
                    padding: EdgeInsets.only(right: 24.0, top: deviceSize.height * 0.09),
                    child: isFollow == true
                         ?SpqTextbutton(
                            onPressed: () {
                              setState(
                                () {
                                  isFollow = false;
                                },
                              );
                            },
                            name: _unfollow,
                            style: const TextStyle(color:  spqErrorRed),
                          )
                        : SpqTextbutton(
                            onPressed: () {
                              setState(
                                () {
                                  isFollow = true;
                                },
                              );
                            },
                            name: _follow,
                           style: const TextStyle(color:spqPrimaryBlue ),
                          ),
                  )*/
            ],
          ),
          _buildProfileInformation(context, deviceSize),
        ],
      ),
    );
  }

  Widget _buildProfileInformation(BuildContext context, Size deviceSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _name,
          style: const TextStyle(
              color: spqBlack, fontWeight: FontWeight.bold, fontSize: 23),
        ),
        Text(
          _username,
          style: const TextStyle(
            color: spqDarkGrey,
            fontSize: 18,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            _bio,
            style: const TextStyle(color: spqBlack, fontSize: 19),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              const Icon(Icons.link),
              Text(
                _link,
                style: const TextStyle(color: spqPrimaryBlue, fontSize: 16),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.calendar_month),
              Text(
                _joined,
                style: const TextStyle(color: spqDarkGrey, fontSize: 16),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => Navigator.pushNamed(context, 'follow'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  _following,
                  style: const TextStyle(
                      color: spqBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const SizedBox(width: 25),
              Text(
                _follower,
                style: const TextStyle(
                    color: spqBlack, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(Size deviceSize) {
    return SizedBox(
      width: deviceSize.width,
      height: double.maxFinite,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const TabBar(
            unselectedLabelColor: spqDarkGrey,
            indicatorColor: spqPrimaryBlue,
            labelColor: spqPrimaryBlue,
            tabs: [
              Text(
                'Speaqs',
                style: TextStyle(fontSize: 23),
              ),
              Text(
                'Likes',
                style: TextStyle(fontSize: 23),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: TabBarView(
              children: [
                listViewPostText(),
                listViewPostText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listViewPostText() {
    return Column(
      children: [
        PostContainer(
            name: _name, username: _username, postMessage: _postMessage),
        const Divider(thickness: 0.55, color: spqLightGreyTranslucent),
        PostContainer(
            name: _name, username: _username, postMessage: _postMessage),
        const Divider(thickness: 0.55, color: spqLightGreyTranslucent),
        PostContainer(
            name: _name, username: _username, postMessage: _postMessage),
      ],
    );
  }
}
