import 'package:flutter/material.dart';

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
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          _buildHeader(deviceSize, context),
          _buildTabs(deviceSize),
        ],
      ),
    );
  }

  SizedBox _buildHeader(Size deviceSize, BuildContext context) => SizedBox(
      width: deviceSize.width,
      height: deviceSize.height * 0.55,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(top: 0, child: _buildCover(deviceSize)),
          Positioned(
              top: deviceSize.height * 0.15, height: deviceSize.height * 0.17, width: deviceSize.width, child: _buildPictureEditProfile(deviceSize)),
          /*
          Positioned(top: 115, child: _buildProfilePicture(deviceSize)),
          Positioned(top: 155, right: 20, child: _buildEditButton(context)),
*/

          Positioned(top: 190, child: _buildProfileInformation(context, deviceSize)),
        ],
      ));

  Widget _buildCover(Size deviceSize) {
    return Container(
        height: deviceSize.height * 0.225,
        width: deviceSize.width,
        decoration: const BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
              fit: BoxFit.cover, image: NetworkImage('https://www.jobvector.de/karriere-ratgeber/wp-content/uploads/2021/05/it-security360x240.jpg')),
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
          padding: const EdgeInsets.only(right: 24.0),
          child: _buildEditButton(context, deviceSize),
        )
      ],
    );
  }

  Widget _buildProfilePicture(Size deviceSize) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => buildHero(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

  Widget _buildEditButton(BuildContext context, Size deviceSize) {
    return Padding(
      padding: EdgeInsets.only(top: deviceSize.height * 0.09),
      child: ElevatedButton(
        onPressed: reset,
        child: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.blue),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(
                color: Colors.blue,
              )),
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
          const Text('Corinna', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30)),
          const Text('@corinna',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              )),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Text('I like big America', style: TextStyle(color: Colors.black, fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: const [
                Icon(Icons.link),
                Text('@corinna.io', style: TextStyle(color: Colors.blue)),
                SizedBox(width: 15),
                Icon(Icons.calendar_month),
                Text('Joined September 2018', style: TextStyle(color: Colors.black))
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text('21 Following', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 25),
              Text('117k Followers', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _buildTabs(Size deviceSize) {
    return Container(
      width: deviceSize.width,
      height: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
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
          body: TabBarView(
            children: [
              Text(
                'Speaqs',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                'Likes',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHero(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "@corinna",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
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
