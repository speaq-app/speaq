import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          _buildHeader(size, context),
          _buildTabs(size),
        ],
      ),
    );
  }

  SizedBox _buildHeader(Size size, BuildContext context) => SizedBox(
      width: size.width,
      height: size.height * 0.45,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(top: 0, child: _buildCover(size)),
          Positioned(top: 115, child: _buildProfilePictures(size)),
          Positioned(bottom: 0, child: _buildProfileInformation(context, size))
        ],
      ));

  Widget _buildCover(Size size) {
    return Container(
        height: 160,
        width: size.width,
        decoration: const BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://www.jobvector.de/karriere-ratgeber/wp-content/uploads/2021/05/it-security360x240.jpg')),
        ));
  }

  Widget _buildProfilePictures(Size size) {
    return SizedBox(
      height: 160,
      width: size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      buildHero(context),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
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
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildProfileInformation(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Corinna',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
        const Text('@corinna',
            style: TextStyle(color: Colors.black, fontSize: 18)),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text('I like big Dicks and America',
              style: TextStyle(color: Colors.black, fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: const [
              Icon(Icons.link),
              Text('@corinna.io', style: TextStyle(color: Colors.blue)),
              SizedBox(width: 15),
              Icon(Icons.calendar_month),
              Text('Joined September 2018',
                  style: TextStyle(color: Colors.black))
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
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 25),
            Text('117k Followers',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ]),
    );
  }

  Widget _buildTabs(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const DefaultTabController(
        length: 2,
        child: TabBar(
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
