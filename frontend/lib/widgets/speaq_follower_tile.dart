import 'package:flutter/material.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/utils/all_utils.dart';


class FollowerTile extends StatelessWidget {
  final String followerImage;
  final FollowUser follower;

  const FollowerTile({
    Key? key,
    required this.follower,
    required this.followerImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(context, "contact_details",
          arguments: {"user": follower}),
/*
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContactDetailsPage(contact: contact, contactImage: contactImage))),
*/
      leading: Hero(
          tag: followerImage,
          child:
              CircleAvatar(radius: MediaQuery.of(context).size.width * 0.07)),
      title: Text(
        "${follower.name}",
        style: const TextStyle(
            fontSize: 18.0, color: spqBlack, fontWeight: FontWeight.w900),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(follower.username,
              style: const TextStyle(fontSize: 16.0, color: spqLightGrey)),
        ],
      ),
      isThreeLine: false,
      trailing: ElevatedButton(
        onPressed: () {
          print("unfollow ${follower.username}");
        },
        child: const Text(
          "Unfollow",
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

class Follower {
  Follower(
      {required this.username,
      required this.firstname,
      required this.lastname});

  final String username;
  final String firstname;
  final String lastname;
}
