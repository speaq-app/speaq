import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/api/model/user.dart';
import 'package:frontend/blocs/follower_bloc/follower_bloc.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/widgets_shimmer/shimmer_cube.dart';
import 'package:frontend/widgets_shimmer/shimmer_profile_picture.dart';
import 'package:frontend/widgets_shimmer/shimmer_post.dart';

class ProfilePage extends StatefulWidget {
  final int pageUserID;
  final bool isOwnPage;
  final int initialPageIndex;

  const ProfilePage({
    Key? key,
    required this.pageUserID,
    this.isOwnPage = false,
    this.initialPageIndex = 0,
  }) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ProfileBloc _profileBloc = ProfileBloc();
  final ResourceBloc _resourceBloc = ResourceBloc();
  final FollowerBloc _pageUserFollowerBloc = FollowerBloc();
  final FollowerBloc _followUnfollowBloc = FollowerBloc();

  final String _backgroundImage =
      "https://cdn0.scrvt.com/5b9bbd140a15e188780a6244ebe572d4/772147c289ad227c/ca6d6d455211/v/1abab81df2ad/C_Sont_001_300dpi.jpg";

  List<int> _followerIDs = [];
  List<int> _followingIDs = [];

  late Profile _profile;

  final String _joined = "Joined August 2022";

  @override
  void initState() {
    _loadPage();

    super.initState();
  }

  Future<void> _loadPage() async {
    _profileBloc.add(LoadProfile(userId: widget.pageUserID));
    if (!widget.isOwnPage) {
      _followUnfollowBloc
          .add(CheckIfFollowing(userID: 0, followerID: widget.pageUserID));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
        ),
        body: RefreshIndicator(
          onRefresh: () => _loadPage(),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              _buildProfileCover(deviceSize, context),
              _buildProfileStack(appLocale, deviceSize),
            ],
          ),
        ),
        bottomNavigationBar: SpqButtonNavigationBar(
          switchPage: (index) {
            Navigator.popUntil(context, ModalRoute.withName("base"));
            Navigator.pushNamed(context, "base", arguments: index);
          },
          selectedIndex: widget.initialPageIndex,
        ),
      ),
    );
  }

  Widget _buildProfileCover(Size deviceSize, BuildContext context) {
    return Container(
      height: deviceSize.height * 0.225,
      width: deviceSize.width,
      decoration: BoxDecoration(
        color: spqPrimaryBlue,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(_backgroundImage),
        ),
      ),
    );
  }

  Widget _buildProfileStack(AppLocalizations appLocale, Size deviceSize) {
    return Container(
      transform: Matrix4.translationValues(0, -45, 0),
      // Loads the users profile and, if it succeeded, the users follower data.
      child: BlocConsumer<ProfileBloc, ProfileState>(
        bloc: _profileBloc,
        listener: (context, state) {
          if (state is ProfileLoaded) {
            if (state.profile.profileImageResourceId > 0) {
              _resourceBloc.add(LoadResource(
                  resourceId: state.profile.profileImageResourceId));
            }
            _pageUserFollowerBloc
                .add(LoadFollowerIDs(userId: widget.pageUserID));
            _profile = state.profile;
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return _buildProfilePage(deviceSize, appLocale, state.profile);
          } else if (state is ProfileLoading) {
            return _buildProfilePageShimmer(deviceSize, appLocale);
          }
          return const Text("State failed");
        },
      ),
    );
  }

  Widget _buildProfilePage(
      Size deviceSize, AppLocalizations appLocale, Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildProfilePicture(deviceSize, profile),
              _buildEditProfileButton(deviceSize, appLocale),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child:
              _buildProfileInformation(context, appLocale, deviceSize, profile),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: _buildTabs(deviceSize),
        ),
      ],
    );
  }

  Widget _buildProfilePageShimmer(Size deviceSize, AppLocalizations appLocale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.05),
          child: const ShimmerProfilePicture(diameter: 21.5),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: deviceSize.width * 0.04,
            vertical: deviceSize.width * 0.01,
          ),
          child: _buildProfileInformationShimmer(deviceSize),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: deviceSize.width * 0.01),
          child: _buildTabsShimmer(deviceSize),
        ),
      ],
    );
  }

  /// Creates an editProfile button surrounded with the block pattern.
  Widget _buildEditProfileButton(Size deviceSize, AppLocalizations appLocale) {
    return Container(
      width: deviceSize.width * 0.33,
      height: deviceSize.height * 0.05,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: widget.isOwnPage
          ? SpqTextButton(
              onPressed: () => Navigator.pushNamed(context, 'edit_profile')
                  .then((value) => _profileBloc.add(LoadProfile(userId: 0))),
              name: appLocale.editProfile,
              textStyle: const TextStyle(color: spqPrimaryBlue),
            )
          // Selects the appropriate state and returns the right button.
          : BlocBuilder<FollowerBloc, FollowerState>(
              bloc: _followUnfollowBloc,
              builder: (context, state) {
                if (state is CheckIfFollowingLoaded) {
                  return SpqTextButton(
                    onPressed: () {
                      _followUnfollowBloc.add(FollowUnfollow(
                          userID: 0, followerID: widget.pageUserID));
                      _loadPage();
                    },
                    name: state.isFollowing
                        ? appLocale.toUnfollow
                        : appLocale.toFollow,
                    textStyle: TextStyle(
                        color:
                            state.isFollowing ? spqLightRed : spqPrimaryBlue),
                    borderColor:
                        state.isFollowing ? spqLightRed : spqPrimaryBlue,
                  );
                } else if (state is FollowUnfollowLoaded) {
                  return SpqTextButton(
                    onPressed: () {
                      _followUnfollowBloc.add(FollowUnfollow(
                          userID: 0, followerID: widget.pageUserID));
                      _loadPage();
                    },
                    name: state.isFollowing
                        ? appLocale.toUnfollow
                        : appLocale.toFollow,
                    textStyle: TextStyle(
                        color:
                            state.isFollowing ? spqLightRed : spqPrimaryBlue),
                    borderColor:
                        state.isFollowing ? spqLightRed : spqPrimaryBlue,
                  );
                }
                return Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ShimmerCube(
                    width: deviceSize.width * 0.01,
                    height: deviceSize.height * 0.01,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProfilePicture(Size deviceSize, Profile profile) {
    return BlocBuilder<ResourceBloc, ResourceState>(
      bloc: _resourceBloc,
      builder: (context, state) {
        if (state is ResourceLoaded) {
          if (state.resource.id > 0) {
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      _buildProfileImageFullScreen(context, state.decodedData),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ),
              ),
              child: Hero(
                tag: 'myProfileImage',
                child: CircleAvatar(
                  backgroundColor: spqWhite,
                  radius: 45,
                  child: CircleAvatar(
                    radius: 43,
                    foregroundImage: MemoryImage(state.decodedData),
                    backgroundImage:
                        BlurHashImage(profile.profileImageBlurHash),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: spqPrimaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.add_a_photo,
                  color: spqWhite,
                  size: 38,
                ),
              ),
            );
          }
        } else if (profile.profileImageBlurHash.isNotEmpty) {
          return CircleAvatar(
            backgroundColor: spqWhite,
            radius: 45,
            child: CircleAvatar(
              radius: 43,
              backgroundImage: BlurHashImage(profile.profileImageBlurHash),
            ),
          );
        } else {
          return CircleAvatar(
            backgroundColor: spqPrimaryBlue,
            radius: 45,
            child: Text(profile.name[0].toUpperCase()),
          );
        }
      },
    );
  }

  Widget _buildProfileImageFullScreen(
      BuildContext context, Uint8List decodedData) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _profile.name,
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
            tag: 'myProfileImage',
            child: Image(
              image: MemoryImage(decodedData),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInformation(BuildContext context,
      AppLocalizations appLocale, Size deviceSize, Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.name,
          style: const TextStyle(
            color: spqBlack,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        Text(
          "@${profile.username}",
          style: const TextStyle(
            color: spqDarkGrey,
            fontSize: 18,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            profile.description,
            style: const TextStyle(
              color: spqBlack,
              fontSize: 19,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              const Icon(Icons.link),
              Text(
                profile.website,
                style: const TextStyle(
                  color: spqPrimaryBlue,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.calendar_month),
              Text(
                _joined,
                style: const TextStyle(
                  color: spqDarkGrey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        // Loads the follower and following id's from the user, which page the app user is currently visiting.
        // If it succeeded, it loads the follower and following profile data.
        BlocConsumer<FollowerBloc, FollowerState>(
          bloc: _pageUserFollowerBloc,
          listener: (context, state) {
            if (state is FollowerIDsLoaded) {
              _followerIDs = state.followerIDs;
              _followingIDs = state.followingIDs;
            }
          },
          builder: (context, state) {
            if (state is FollowerIDsLoading) {
              return _buildShimmerFollowerInfo(deviceSize);
            } else {
              return _buildFollowerInfo(context, appLocale);
            }
          },
        ),
      ],
    );
  }

  Widget _buildShimmerFollowerInfo(Size deviceSize) {
    return Container(
      padding: EdgeInsets.only(
        top: deviceSize.width * 0.006,
        bottom: deviceSize.width * 0.005,
        left: deviceSize.width * 0.0037,
      ),
      child: ShimmerCube(
        width: deviceSize.width * 0.2,
        height: 8,
      ),
    );
  }

  InkWell _buildFollowerInfo(BuildContext context, AppLocalizations appLocale) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'follow',
          arguments: User(
            id: widget.pageUserID,
            profile: _profile,
            password: '',
            followerIDs: _followerIDs,
            followingIDs: _followingIDs,
          )),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "${_followerIDs.length} ${appLocale.follower}",
              style: const TextStyle(
                color: spqBlack,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 25),
          Text(
            "${_followingIDs.length} ${appLocale.following}",
            style: const TextStyle(
              color: spqBlack,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInformationShimmer(Size deviceSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: deviceSize.width / 100 * 2),
        const ShimmerCube(width: 20, height: 5),
        SizedBox(height: deviceSize.width / 100 * 3),
        const ShimmerCube(width: 30, height: 4),
        SizedBox(height: deviceSize.width / 100 * 3),
        const ShimmerCube(width: 100, height: 4),
        SizedBox(height: deviceSize.width / 100 * 2),
        const ShimmerCube(width: 100, height: 4),
        SizedBox(height: deviceSize.width / 100 * 2),
        const ShimmerCube(width: 60, height: 4),
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
                _buildPostsContainer(deviceSize),
                _buildPostsContainer(deviceSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabsShimmer(Size deviceSize) {
    return SizedBox(
      width: deviceSize.width,
      height: double.maxFinite,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const TabBar(
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
                _buildPostContainerShimmer(),
                _buildPostContainerShimmer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostsContainer(Size deviceSize) {
    return Column(
      children: [
        SizedBox(
          height: deviceSize.height * 0.75,
          child: Container(
            color: spqPrimaryBlue,
            child: const Center(
              child: Text(
                "coming soon...",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostContainerShimmer() {
    return ListView(
      children: const [
        PostShimmer(),
        PostShimmer(hasImage: true),
        PostShimmer(hasAudio: true),
        PostShimmer(),
        PostShimmer(),
        PostShimmer(hasImage: true),
      ],
    );
  }

  @override
  void dispose() {
    _profileBloc.close();
    _resourceBloc.close();
    _pageUserFollowerBloc.close();
    _followUnfollowBloc.close();

    super.dispose();
  }
}
