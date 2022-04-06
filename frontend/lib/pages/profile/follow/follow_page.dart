import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class Follower {
  Follower({required this.username});

  final String username;
}

class _FollowPageState extends State<FollowPage> {
  int followerCount = 522;
  int followingCount = 14;

  List<Follower> follower = [Follower(username: "Nosa"), Follower(username: "David"), Follower(username: "Sven"), Follower(username: "Hendrik")];
  List<Follower> following = [Follower(username: "Eric"), Follower(username: "Daniel")];

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.username),
          bottom: TabBar(
            indicatorWeight: 1.5,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: spqLightGrey,
            indicatorColor: spqPrimaryBlue,
            labelColor: spqPrimaryBlue,
            tabs: [
              SizedBox(
                height: deviceSize.height * 0.05,
                child: Text(
                  "$followerCount Follower",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: deviceSize.height * 0.05,
                child: Text(
                  "$followingCount Following",
                  style: const TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildFollowerList(deviceSize), _buildFollowingList()],
        ),
      ),
    );
  }

  Widget _buildFollowerList(Size deviceSize) {
    return Column(
      children: [
        SizedBox(
          height: deviceSize.height * 0.75,
          child: ListView.builder(
              shrinkWrap: false,
              itemBuilder: (context, index) {
                Follower currentFollower = follower[index];
                //Hier image von Server laden
                Image availableImage;
                print(currentFollower.username);
                /*Try catch funktioniert noch nicht, wenn ich überprüfen will, ob eine URL gültig ist. Daher auskommentiert*/
/*
                          if (contact.image != null && contact.image != '') {
                            try{
                              availableImage = Image.network(contact.image!);
                            }on ArgumentError catch(err){
                              availableImage = Image.asset('resources/images/no_profile_picture.jpg');
                              print("URI for ${contact.firstname} ${contact.lastname}is invalid");
                            }
                          } else {
                            availableImage = Image.asset('resources/images/no_profile_picture.jpg');
                          }*/

                availableImage = Image.asset('resources/images/no_profile_picture.jpg');

                return FollowerTile(follower: currentFollower, followerImage: "lol");
              },
              itemCount: follower.length),
        ),
      ],
    );
  }

  Widget _buildFollowingList() {
    return Container(
      child: const Text("Following"),
    );
  }
}

class FollowerTile extends StatelessWidget {
  const FollowerTile({Key? key, required this.follower, required this.followerImage}) : super(key: key);

  final String followerImage;

  final Follower follower;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(context, "contact_details", arguments: {"user": follower}),
/*
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContactDetailsPage(contact: contact, contactImage: contactImage))),
*/
      leading: Hero(tag: followerImage, child: CircleAvatar(radius: MediaQuery.of(context).size.width * 0.07)),
      title: Text(
        "${follower.username} ${follower.username}",
        style: const TextStyle(fontSize: 18.0, color: spqBlack, fontWeight: FontWeight.w900),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(follower.username, style: const TextStyle(fontSize: 16.0, color: spqLightGrey)),
        ],
      ),
      isThreeLine: false,
      trailing: ElevatedButton(
        onPressed: () {
          print("delete ${follower.username}");
        },
        child: const Text(
          "Delete",
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
}
