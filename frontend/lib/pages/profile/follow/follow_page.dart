import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/api/model/user.dart';
import 'package:frontend/blocs/follower_bloc/follower_bloc.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/widgets_shimmer/components/shimmer_cube.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({Key? key, required this.user}) : super(key: key);

  final User? user;

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  final FollowerBloc _followerBloc = FollowerBloc();
  final ProfileBloc _profileBloc = ProfileBloc();
  late final User? _user;

  @override
  void initState() {
    super.initState();
    //_user=widget.user;
    _user = User(
      id: 1,
      profile: Profile(name: "Karl Ess", username: "essiggurke", description: "Leude ihr müsst husteln! Macht erscht mal die Basics!", website: "ess.com"),
      followerIDs: [2, 3],
      followingIDs: [2, 3],
      password: 'OpenToWork',
    );
    _followerBloc.add(LoadFollowerIDs(
      userId: 1,
    ));
  }

  int followerCount = 0;
  int followingCount = 0;

  List<FollowUser> follower = [];
  List<FollowUser> following = [];

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: BlocConsumer<FollowerBloc, FollowerState>(
          bloc: _followerBloc,
          listener: (context, state) async {
            if (state is FollowerIDsLoaded) {
              var follower = state.followerIDs;
              print(follower);
              followerCount = state.followerIDs.length;
              followingCount = state.followingIDs.length;

              _followerBloc.add(LoadFollower(followerIDs: state.followerIDs, followingIDs: state.followingIDs));
            }
          },
          builder: (context, state) {
            if (state is FollowerIDsLoading) {
              return Scaffold(
                /*appBar: SpqAppBarShimmer(preferredSize: deviceSize),*/
                body: _buildShimmerList(deviceSize),
              );
            } else if (state is FollowerIDsLoaded) {
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
                          "$followerCount ${appLocale.follower}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: deviceSize.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "$followingCount ${appLocale.following}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        )),
                  ],
                ),
                body: _buildShimmerList(deviceSize),
              );
            } else if (state is FollowerLoading) {
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
                          "$followerCount ${appLocale.follower}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: deviceSize.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "$followingCount ${appLocale.following}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        )),
                  ],
                ),
                body: _buildShimmerList(deviceSize),
              );
            } else if (state is FollowerLoaded) {
              followerCount = state.follower.length;
              followingCount = state.following.length;

              follower = state.follower;
              following = state.following;

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
                          "$followerCount ${appLocale.follower}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: deviceSize.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "$followingCount ${appLocale.following}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        )),
                  ],
                ),
                body: TabBarView(
                  children: [_buildFollowerTab(deviceSize, follower), _buildFollowingList(deviceSize, following)],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView _buildShimmerList(Size deviceSize) {
    return SingleChildScrollView(
      child: Column(
        children: [for (int i = 0; i <= 10; i++) Padding(padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0), child: ShimmerCube(width: double.infinity, height: deviceSize.height * 0.025))],
      ),
    );
  }

  Widget _buildFollowingList(Size deviceSize, List<FollowUser> followerList) {
    return Column(
      children: [
        SizedBox(
          height: deviceSize.height * 0.75,
          child: _buildFollowList(followerList),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _profileBloc.close();
    _followerBloc.close();

    super.dispose();
  }
}

Widget _buildFollowerTab(Size deviceSize, List<FollowUser> followingList) {
  return Column(
    children: [
      SizedBox(
        height: deviceSize.height * 0.75,
        child: _buildFollowList(followingList),
      ),
    ],
  );
}

ListView _buildFollowList(List<FollowUser> followerList) {
  return ListView.builder(
      shrinkWrap: false,
      itemBuilder: (context, index) {
        FollowUser currentFollower = followerList[index];
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

        return FollowerTile(follower: currentFollower, followerImage: currentFollower.username);
      },
      itemCount: followerList.length);
}

class FollowerSearchDelegate extends SearchDelegate {
  FollowerSearchDelegate({required this.followerList});

  List<FollowUser> followerList = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear_outlined))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () => close(context, null), icon: Icon(Icons.adaptive.arrow_back_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<FollowUser> matchQuery = [];

    for (FollowUser currentFollower in followerList) {
      if (currentFollower.name.isNotEmpty ? currentFollower.name.toLowerCase().contains(query.toLowerCase()) : false) {
        matchQuery.add(currentFollower);
      }
    }

    return _buildFollowList(matchQuery);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<FollowUser> matchQuery = [];

    for (FollowUser currentFollower in followerList) {
      if (currentFollower.name.isNotEmpty ? currentFollower.name.toLowerCase().contains(query.toLowerCase()) : false) {
        matchQuery.add(currentFollower);
      }
    }

    return _buildFollowList(matchQuery);
  }
}
