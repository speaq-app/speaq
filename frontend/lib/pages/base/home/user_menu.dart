import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets_shimmer/components/shimmer_cube.dart';
import 'package:frontend/widgets_shimmer/components/shimmer_profile_picture.dart';
import 'package:shimmer/shimmer.dart';
import 'package:frontend/blocs/settings_bloc/settings_bloc.dart';
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

  String follower = "234";

  String following = "690";

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

  Widget _buildHeaderShimmer(BuildContext context, AppLocalizations appLocale, Size deviceSize) {
    return Container(
      padding: EdgeInsets.only(
        top: deviceSize.width / 100 * 6,
        bottom: deviceSize.width / 100 * 5,
        left: deviceSize.width / 100 * 3.7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerProfilePicture(diameter: 11.5),
          SizedBox(height: deviceSize.width / 100 * 2.6),
          const ShimmerCube(
            width: 20,
            height: 6,
          ),
          SizedBox(height: deviceSize.width / 100 * 2.6),
          const ShimmerCube(
            width: 30,
            height: 4,
          ),
          SizedBox(height: deviceSize.width / 100 * 1.1),
          const ShimmerCube(
            width: 40,
            height: 4,
          ),
        ],
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
          title: Text(appLocale.profile),
          onTap: () {
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
    super.dispose();
  }
}
