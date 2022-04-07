import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            _buildHeader(deviceSize, context),
            _buildTabs(deviceSize),
          ]),
    );
  }

  SizedBox _buildHeader(Size deviceSize, BuildContext context) =>
      SizedBox(
          width: deviceSize.width,
          height: deviceSize.height * 0.50,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(top: 0, child: _buildCover(deviceSize)),
              Positioned(
                  top: deviceSize.height * 0.13,
                  height: deviceSize.height * 0.17,
                  width: deviceSize.width,
                  child: _buildPictureEditProfile(deviceSize)),
              Positioned(
                  top: 210, child: _buildProfileInformation(context, deviceSize)),
            ],
          ));

  Widget _buildCover(Size deviceSize) {
    return Container(
        height: deviceSize.height * 0.225,
        width: deviceSize.width,
        decoration: const BoxDecoration(
          color: spqPrimaryBlue,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://www.jobvector.de/karriere-ratgeber/wp-content/uploads/2021/05/it-security360x240.jpg')),
        ));
  }

  Widget _buildPictureEditProfile(Size deviceSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: _buildProfilePicture(deviceSize),
        ),
        Padding(
          padding:  EdgeInsets.only(right: 24.0,top: deviceSize.height * 0.09),
          child: SpqTextButton(onPressed: reset,),
        )
      ],
    );
  }

  Widget _buildProfilePicture(Size deviceSize) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                _buildProfileImageFullScreen(context),
            transitionsBuilder: (context, animation, secondaryAnimation,
                child) {
              return child;
            },
          )),
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

  Widget _buildProfileInformation(BuildContext context, Size deviceSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        width: deviceSize.width,
        height: deviceSize.height * 0.3,
        padding: const EdgeInsets.only(top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Corinna',
              style: TextStyle(
                  color: spqBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 30)),
          const Text('@corinna',
              style: TextStyle(
                color: spqDarkGrey,
                fontSize: 18,
              )),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Text('I like big America',
                style: TextStyle(color: spqBlack, fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: const [
                Icon(Icons.link),
                Text('@corinna.io', style: TextStyle(color: spqPrimaryBlue)),
                SizedBox(width: 15),
                Icon(Icons.calendar_month),
                Text('Joined September 2018',
                    style: TextStyle(color: spqDarkGrey))
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text('21 Following',
                    style: TextStyle(
                        color: spqBlack, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 25),
              Text('117k Followers',
                  style: TextStyle(
                      color: spqBlack, fontWeight: FontWeight.bold)),
            ],
          ),
        ]),
      ),
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
              children: [listViewPostText(deviceSize), listViewPostText(deviceSize)],
            ),
          ),
        ),
      ),
    );
  }

  Widget listViewPostText(Size deviceSize) {
    return Column(children: const [
      PostContainer(),
      Divider(thickness: 0.5, color: spqLightGreyTranslucent),
      PostContainer(),
      Divider(thickness: 0.5, color: spqLightGreyTranslucent),
      PostContainer()
    ]);
  }

  Widget _buildProfileImageFullScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "@corinna",
          style: TextStyle(color: spqBlack),
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

  void reset() {}
}

class PostContainer extends StatelessWidget {
  const PostContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.jobvector.de/karriere-ratgeber/wp-content/uploads/2021/05/it-security360x240.jpg'),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text("Corinna Kopf",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text("@Corinna",
                        style: TextStyle(fontSize: 15, color: spqDarkGrey)),
                  ),
                  Text("12/39/19",
                      style: TextStyle(fontSize: 15, color: spqDarkGrey))
                ],
              )
            ],
          ),
          subtitle: Column(
            children: [
              const Text(
                "Hello and Welcome to  America lover Corinna, very nice to see you guys,"
                    "Download: i.dont.know.this.link.io #beer#beer#beer#beer#beer#beer",
                overflow: TextOverflow.clip,
                style: TextStyle(color: spqBlack, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.mic, color: spqDarkGrey),
                  Text("69"),
                  SizedBox(width: 30),
                  Icon(Icons.favorite, color: spqErrorRed),
                  Text("238"),
                  SizedBox(width: 30),
                  Icon(Icons.ios_share, color: spqDarkGrey),
                  SizedBox(width: 30),
                  Icon(Icons.bookmark, color: spqDarkGrey)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class SpqTextButton extends StatelessWidget {
  const SpqTextButton({Key? key,void function, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed,
      child: const Text(
        "Edit Profile",
        style: TextStyle(color: spqPrimaryBlue),
      ),
      style: ElevatedButton.styleFrom(
        primary: spqWhite,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(
              color: spqPrimaryBlue,
            )),
      ),
    );
  }
}
