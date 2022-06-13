import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/api/model/user.dart';
import 'package:frontend/blocs/follower_bloc/follower_bloc.dart';
import 'package:frontend/utils/speaq_styles.dart';
import 'package:frontend/widgets/all_widgets.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({Key? key, required this.user})
      : super(key: key);


  final User? user;

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  final FollowerBloc _followerBloc = FollowerBloc();
  late final User? _user;

  @override
  void initState() {
    super.initState();
    //_user=widget.user;
    _user=User(id: 1, profile: Profile(name: "name", username: "username", description: "description", website: "website"), followerIDs: [], followingIDs: []);
    _followerBloc.add(LoadFollower(
      userId: 1,

    ));
  }

  int followerCount = 0;
  int followingCount = 14;

  List<Follower> follower = [
    Follower(username: "nomoruyi", firstname: "Nosakhare", lastname: "Omoruyi"),
    Follower(username: "dloewe", firstname: "David", lastname: "Loewe"),
    Follower(username: "sgatnar", firstname: "Sven", lastname: "Gatnar")
  ];
  List<Follower> following = [];

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: BlocConsumer<FollowerBloc, FollowerState>(
          bloc: _followerBloc,
          listener: (context, state) async {
            if (state is FollowerLoaded) {
              var follower = state.follower;
              followerCount = follower as int;

            }
          },
          builder: (context, state) {
            return Scaffold(
                appBar: TabBar(
                  indicatorWeight: 1.5,
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: spqLightGrey,
                  indicatorColor: spqPrimaryBlue,
                  labelColor: spqPrimaryBlue,
                  tabs: [
                    SizedBox(
                      height: deviceSize.height * 0.05,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "$followerCount Follower",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: deviceSize.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "$followingCount Following",
                            style: const TextStyle(fontSize: 20),
                          ),
                        )),
                  ],
                ),
                body: TabBarView(
                  children: [
                    _buildFollowerTab(deviceSize, follower),
                    _buildFollowingList()
                  ],
                ));
          },
        ),
      ),
    );
  }

  Widget _buildFollowingList() {
    return const Text("Following");
  }
}

Widget _buildFollowerTab(Size deviceSize, List<Follower> followerList) {
  return Column(
    children: [
      SizedBox(
        height: deviceSize.height * 0.75,
        child: _buildFollowList(followerList),
      ),
    ],
  );
}

ListView _buildFollowList(List<Follower> followerList) {
  return ListView.builder(
      shrinkWrap: false,
      itemBuilder: (context, index) {
        Follower currentFollower = followerList[index];
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

        return FollowerTile(
            follower: currentFollower, followerImage: currentFollower.username);
      },
      itemCount: followerList.length);
}

class FollowerSearchDelegate extends SearchDelegate {
  FollowerSearchDelegate({required this.followerList});

  List<Follower> followerList = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () => query = "", icon: const Icon(Icons.clear_outlined))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: Icon(Icons.adaptive.arrow_back_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Follower> matchQuery = [];

    for (Follower currentFollower in followerList) {
      if ((currentFollower.firstname.isNotEmpty
              ? currentFollower.firstname
                  .toLowerCase()
                  .contains(query.toLowerCase())
              : false) ||
          (currentFollower.lastname.isNotEmpty
              ? currentFollower.lastname
                  .toLowerCase()
                  .contains(query.toLowerCase())
              : false)) {
        matchQuery.add(currentFollower);
      }
    }

    return _buildFollowList(matchQuery);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Follower> matchQuery = [];

    for (Follower currentFollower in followerList) {
      if ((currentFollower.firstname.isNotEmpty
              ? currentFollower.firstname
                  .toLowerCase()
                  .contains(query.toLowerCase())
              : false) ||
          (currentFollower.lastname.isNotEmpty
              ? currentFollower.lastname
                  .toLowerCase()
                  .contains(query.toLowerCase())
              : false)) {
        matchQuery.add(currentFollower);
      }
    }

    return _buildFollowList(matchQuery);
  }
}
