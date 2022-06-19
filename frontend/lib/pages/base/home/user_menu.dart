import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/api/model/user.dart';
import 'package:frontend/blocs/follower_bloc/follower_bloc.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/blocs/settings_bloc/settings_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets_shimmer/components/shimmer_cube.dart';
import 'package:frontend/widgets_shimmer/components/shimmer_profile_picture.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({Key? key}) : super(key: key);

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  final ProfileBloc _profileBloc = ProfileBloc();
  final ResourceBloc _resourceBloc = ResourceBloc();
  final SettingsBloc _settingsBloc = SettingsBloc();
  final FollowerBloc _followerBloc = FollowerBloc();

  //Follower
  int _followerCount = 0;
  int _followingCount = 0;

  //App User (beim login holen)
  final User _user = User(
    id: 1,
    profile: Profile(name: "Karl Ess", username: "essiggurke", description: "Leude ihr müsst husteln! Macht erscht mal die Basics!", website: "ess.com"),
    followerIDs: [2, 3],
    followingIDs: [2, 3],
    password: 'OpenToWork',
  );

  @override
  void initState() {
    _profileBloc.add(LoadProfile(
      userId: 1,
    ));
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;

    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BlocBuilder<ProfileBloc, ProfileState>(
                bloc: _profileBloc,
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return _buildHeaderShimmer(context, appLocale, deviceSize);
                  } else if (state is ProfileLoaded) {
                    _resourceBloc.add(LoadResource(resourceId: state.profile.profileImageResourceId));
                    _followerBloc.add(LoadFollowerIDs(userId: _user.id));
                    return _buildHeader(context, appLocale, deviceSize, state.profile);
                  } else {
                    return const Text("Error UserMenuState");
                  }
                },
              ),
              _buildMenu(context, appLocale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer(BuildContext context, AppLocalizations appLocale, Size deviceSize) {
    return Container(
      padding: EdgeInsets.only(
        top: deviceSize.width * 0.06,
        bottom: deviceSize.width * 0.05,
        left: deviceSize.width * 0.037,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerProfilePicture(diameter: 11.5),
          SizedBox(height: deviceSize.width * 0.026),
          const ShimmerCube(
            width: 20,
            height: 6,
          ),
          SizedBox(height: deviceSize.width * 0.026),
          const ShimmerCube(
            width: 30,
            height: 4,
          ),
          SizedBox(height: deviceSize.width * 0.011),
          const ShimmerCube(
            width: 40,
            height: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations appLocale, Size deviceSize, Profile profile) {
    return Container(
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 24,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ResourceBloc, ResourceState>(
              bloc: _resourceBloc,
              builder: (context, state) {
                if (state is ResourceLoaded) {
                  return CircleAvatar(
                    radius: 24,
                    backgroundImage: MemoryImage(state.decodedData),
                  );
                } else {
                  return CircleAvatar(
                    radius: 24,
                    backgroundImage: BlurHashImage(profile.profileImageBlurHash),
                  );
                }
              },
            ),
            const SizedBox(height: 5),
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              profile.username,
              style: const TextStyle(fontSize: 15),
            ),
            BlocConsumer<FollowerBloc, FollowerState>(
              bloc: _followerBloc,
              listener: (context, state) {
                if (state is FollowerIDsLoaded) {
                  _followerCount = state.followerIDs.length;
                  _followingCount = state.followingIDs.length;
                }
              },
              builder: (context, state) {
                if (state is FollowerIDsLoaded) {
                  return _buildFollowerInfo(context, appLocale);
                } else if (state is FollowerIDsLoading) {
                  return _buildShimmerFollowerInfo(deviceSize);
                } else {
                  return _buildShimmerFollowerInfo(deviceSize);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerFollowerInfo(Size deviceSize) {
    return Container(
      padding: EdgeInsets.only(
        top: deviceSize.width * 0.006,
        bottom: deviceSize.width * 0.005,
        left: deviceSize.width * 0.0037,
      ),
      child: const ShimmerCube(
        width: 20,
        height: 3,
      ),
    );
  }

  Widget _buildFollowerInfo(BuildContext context, AppLocalizations appLocale) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'follow', arguments: _user),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              children: [
                Text(
                  "$_followerCount",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    appLocale.follower,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Text(
                    "$_followingCount",
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  appLocale.following,
                  style: const TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, AppLocalizations appLocale) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(appLocale.profile),
          onTap: () {
            //TODO User übergeben
            Navigator.popAndPushNamed(context, "profile");
          },
        ),
        ListTile(
          leading: const Icon(Icons.qr_code_2),
          title: Text(appLocale.qrCode),
          onTap: () {
            Navigator.popAndPushNamed(context, "qr_code");
          },
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_border),
          title: Text(appLocale.bookmarks),
          onTap: () {
            Navigator.popAndPushNamed(context, "bookmarks");
          },
        ),
        const Divider(
          color: Colors.black54,
          thickness: 0.75,
        ),
        ListTile(
          title: Text(appLocale.settingsandprivacy),
          onTap: () {
            Navigator.popAndPushNamed(context, "settings");
          },
        ),
        BlocConsumer<SettingsBloc, SettingsState>(
          bloc: _settingsBloc,
          listener: (context, state) async {
            if (state is ImprintURLLoaded) {
              await launchUrl(state.imprintURL);
            }
          },
          builder: (context, state) {
            if (state is LoadingImprintURL) {
              return ListTile(
                title: Text(appLocale.imprint),
                trailing: const CircularProgressIndicator(),
              );
            }

            return ListTile(
              title: Text(appLocale.imprint),
              onTap: () {
                _settingsBloc.add(LoadImprintURL());
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _settingsBloc.close();
    _followerBloc.close();
    _profileBloc.close();
    _resourceBloc.close();

    super.dispose();
  }
}
