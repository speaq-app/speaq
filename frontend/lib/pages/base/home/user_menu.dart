import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:shimmer/shimmer.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({Key? key}) : super(key: key);

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  // final UserMenuBloc _userMenuBloc = UserMenuBloc();
  final ProfileBloc _profileBloc = ProfileBloc();
  final ResourceBloc _resourceBloc = ResourceBloc();

  String follower = "234";

  String following = "690";

  @override
  void initState() {
    //Change from Hardcoded
    _profileBloc.add(LoadProfile(userId: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;

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
                    return _buildHeaderShimmer(context, appLocale);
                  } else if (state is ProfileLoaded) {
                    _resourceBloc.add(LoadResource(resourceId: state.profile.profileImageResourceId));
                    return _buildHeader(context, appLocale, state.profile);
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

  Widget _buildHeaderShimmer(BuildContext context, AppLocalizations appLocale) {
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
            Shimmer.fromColors(
              baseColor: spqLightGrey,
              highlightColor: spqWhite,
              child: const CircleAvatar(radius: 24),
            ),
            const SizedBox(height: 13),
            Shimmer.fromColors(
              baseColor: spqLightGrey,
              highlightColor: spqWhite,
              child: const SizedBox(
                width: 180,
                height: 25,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: spqBlack),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Shimmer.fromColors(
              baseColor: spqLightGrey,
              highlightColor: spqWhite,
              child: const SizedBox(
                width: 100,
                height: 15,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: spqBlack),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor: spqLightGrey,
              highlightColor: spqWhite,
              child: const SizedBox(
                width: 120,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: spqBlack),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations appLocale, Profile profile) {
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
            InkWell(
              onTap: () => Navigator.pushNamed(context, 'follow'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Row(
                      children: [
                        Text(
                          following,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            appLocale.following,
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
                            follower,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          appLocale.follower,
                          style: const TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, AppLocalizations appLocale) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text("Profile"),
          onTap: () {
            Navigator.popAndPushNamed(context, "profile");
          },
        ),
        ListTile(
          leading: const Icon(Icons.qr_code_2),
          title: const Text("QR-Code"),
          onTap: () {
            Navigator.popAndPushNamed(context, "qr_ode");
          },
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_border),
          title: const Text("Bookmarks"),
          onTap: () {
            Navigator.popAndPushNamed(context, "bookmarks");
          },
        ),
        const Divider(
          color: Colors.black54,
          thickness: 0.75,
        ),
        ListTile(
          title: const Text("Settings and privacy"),
          onTap: () {
            Navigator.popAndPushNamed(context, "settings");
          },
        ),
        ListTile(
          title: const Text("Impressum"),
          onTap: () {
            Navigator.popAndPushNamed(context, "impressum");
          },
        ),
      ],
    );
  }
}
