import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:frontend/api/model/user.dart';
import 'package:frontend/blocs/follower_bloc/follower_bloc.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/widgets_shimmer/components/shimmer_cube.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  final FollowerBloc _followerBloc = FollowerBloc();
  final ProfileBloc _profileBloc = ProfileBloc();

  int _followerCount = 0;
  int _followingCount = 0;

  List<CondensedUser> _follower = [];
  List<CondensedUser> _following = [];

  @override
  void initState() {
    super.initState();

    _followerBloc.add(LoadFollowerIDs(userId: widget.user.id));
  }

  Future<void> refresh() async {
    _followerBloc.add(LoadFollowerIDs(userId: widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: SpqAppBar(
            preferredSize: deviceSize,
          ),
          // Loads first the follower and following id's and then their profile.
          body: BlocConsumer<FollowerBloc, FollowerState>(
            bloc: _followerBloc,
            listener: (context, state) async {
              if (state is FollowerIDsLoaded) {
                _followerCount = state.followerIDs.length;
                _followingCount = state.followingIDs.length;

                _followerBloc.add(LoadFollower(
                    followerIDs: state.followerIDs,
                    followingIDs: state.followingIDs));
              } else if (state is FollowerLoaded) {
                _follower = state.follower;
                _following = state.following;
              }
            },
            builder: (context, state) {
              if (state is FollowerLoaded) {
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
                            "$_followerCount ${appLocale.follower}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceSize.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "$_followingCount ${appLocale.following}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: TabBarView(
                    children: [
                      _buildFollowerList(deviceSize, _follower),
                      _buildFollowingList(deviceSize, _following)
                    ],
                  ),
                );
              } else {
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
                            "$_followerCount ${appLocale.follower}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceSize.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "$_followingCount ${appLocale.following}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: _buildShimmerList(deviceSize),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _buildShimmerList(Size deviceSize) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i <= 10; i++)
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ShimmerCube(
                    width: double.infinity, height: deviceSize.height * 0.024)
            )
        ],
      ),
    );
  }

  Widget _buildFollowerList(Size deviceSize, List<CondensedUser> followerList) {
    return Column(
      children: [
        SizedBox(
          height: deviceSize.height * 0.75,
          child: _buildFollowList(deviceSize, followerList),
        ),
      ],
    );
  }

  Widget _buildFollowingList(
      Size deviceSize, List<CondensedUser> followingList) {
    return Column(
      children: [
        SizedBox(
          height: deviceSize.height * 0.75,
          child: _buildFollowList(deviceSize, followingList),
        ),
      ],
    );
  }

  Widget _buildFollowList(Size deviceSize, List<CondensedUser> followUserList) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
          shrinkWrap: false,
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()
          ),
          itemBuilder: (context, index) {
            CondensedUser currentFollower = followUserList[index];

            return FollowerTile(
              follower: currentFollower,
              onPop: refresh,
            );
          },
          itemCount: followUserList.length
      ),
    );
  }

  @override
  void dispose() {
    _profileBloc.close();
    _followerBloc.close();

    super.dispose();
  }
}