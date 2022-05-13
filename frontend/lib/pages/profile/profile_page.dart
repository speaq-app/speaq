import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_bottom_navi_bar.dart';
import 'package:frontend/widgets/speaq_post_container.dart';
import 'package:frontend/widgets/speaq_text_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Profile
  final ProfileBloc _profileBloc = ProfileBloc();
  final ResourceBloc _resourceBloc = ResourceBloc();

  //Hardcoded for posts - delete later
  final String _name = "testname";
  final String _username = "testUsername";

  //Follower
  final String _follower = "117k Follower";
  final String _following = "69 Following";

  //User-Data
  final String _joined = "Joined August 2022";

  //Posts
  final String _postImage = "https://images.ctfassets.net/l3l0sjr15nav/dGLEVnJ6E3IuJE4NNFX4z/418da4b5783fa29d4abcabb7c37f71b7/2020-06-11_-_Wie_man_schnell_ein_GIF_erstellt.gif";
  final String _postImage2 = "https://www.architekten-online.com/media/03_-hhn-hochschule-heilbronn.jpg";
  final String _postMessage = "Welcome to our presentation, how are you ? Just did something lit here!!! yeah #speaq #beer";

  bool isFollow = false;

  @override
  void initState() {
    _profileBloc.add(LoadProfile(userId: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          title: Text(
            _username,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            _buildProfileCover(deviceSize, context),
            _buildProfileStack(deviceSize),
          ],
        ),
        bottomNavigationBar: SpqButtonNavigationBar(
          switchPage: (index) {
            Navigator.pushNamed(context, "base");
          },
          selectedIndex: 0,
        ),
      ),
    );
  }

  Widget _buildProfileCover(Size deviceSize, BuildContext context) {
    return Container(
      height: deviceSize.height * 0.225,
      width: deviceSize.width,
      decoration: const BoxDecoration(
        color: spqPrimaryBlue,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage('https://cdn0.scrvt.com/5b9bbd140a15e188780a6244ebe572d4/772147c289ad227c/ca6d6d455211/v/1abab81df2ad/C_Sont_001_300dpi.jpg'),
        ),
      ),
    );
  }

  Widget _buildProfileStack(Size deviceSize) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    return Container(
        transform: Matrix4.translationValues(0, -45, 0),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listener: (context, state) {
            if (state is ProfileLoaded) {
              _resourceBloc.add(LoadResource(resourceId: state.profile.profileImageResourceId));
            }
          },
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return _buildProfilePage(deviceSize, appLocale, state.profile);
            } else if (state is ProfileLoading) {
              return const Text("Shimmer");
            } else {
              return const Text("State failed");
            }
          },
        ));
  }

  Widget _buildProfilePage(Size deviceSize, AppLocalizations appLocale, Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildProfilePicture(deviceSize, profile.profileImageBlurHash),
              Container(
                width: deviceSize.width * 0.33,
                height: deviceSize.height * 0.05,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SpqTextbutton(
                  onPressed: () => Navigator.pushNamed(context, 'edit_profile'),
                  name: appLocale.editProfile,
                  style: const TextStyle(color: spqPrimaryBlue),
                ),
              ),
              /*Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: deviceSize.width * 0.31,
                  height: deviceSize.height * 0.05,
                  child: isFollow == true
                      ? SpqTextbutton(
                          onPressed: () {
                            setState(
                              () {
                                isFollow = false;
                              },
                            );
                          },
                          name: _unfollow,
                          style: const TextStyle(color: spqErrorRed),
                        )
                      : SpqTextbutton(
                          onPressed: () {
                            setState(
                              () {
                                isFollow = true;
                              },
                            );
                          },
                          name: _follow,
                          style: const TextStyle(color: spqPrimaryBlue),
                        ),
                ),*/
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: _buildProfileInformation(context, deviceSize, profile),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: _buildTabs(deviceSize),
        ),
      ],
    );
  }

  Widget _buildProfilePicture(Size deviceSize, String profileImageBlurHash) {
    return BlocBuilder<ResourceBloc, ResourceState>(
        bloc: _resourceBloc,
        builder: (context, state) {
          if (state is ResourceLoaded) {
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => _buildProfileImageFullScreen(context, state.decodedData),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ),
              ),
              child: Hero(
                tag: 'myImage',
                child: CircleAvatar(
                  backgroundColor: spqWhite,
                  radius: 45,
                  child: CircleAvatar(
                    radius: 43,
                    backgroundImage: MemoryImage(state.decodedData),
                  ),
                ),
              ),
            );
          } else {
            return CircleAvatar(
              backgroundColor: spqWhite,
              radius: 45,
              child: CircleAvatar(
                radius: 43,
                backgroundImage: BlurHashImage(profileImageBlurHash),
              ),
            );
          }
        });
  }

  Widget _buildProfileImageFullScreen(BuildContext context, Uint8List decodedData) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _username,
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
            tag: 'myImage',
            child: Image(
              image: MemoryImage(decodedData),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInformation(BuildContext context, Size deviceSize, Profile profile) {
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
          profile.username,
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
        InkWell(
          onTap: () => Navigator.pushNamed(context, 'follow'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  _follower,
                  style: const TextStyle(
                    color: spqBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Text(
                _following,
                style: const TextStyle(
                  color: spqBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
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
                _buildPostContainer(),
                _buildPostContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostContainer() {
    return Column(
      children: [
        const SizedBox(height: 10),
        PostContainer(
          name: _name,
          username: _username,
          postMessage: _postMessage,
          postImage: Image.network(_postImage),
        ),
        const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
        PostContainer(
          name: _name,
          username: _username,
          postMessage: _postMessage,
          postImage: Image.network(_postImage2),
        ),
        const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
        PostContainer(
          name: _name,
          username: _username,
          postMessage: _postMessage,
        ),
        const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
        PostContainer(
          name: _name,
          username: _username,
          postMessage: _postMessage,
          postImage: Image.network(_postImage),
        ),
        const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
        PostContainer(
          name: _name,
          username: _username,
          postMessage: _postMessage,
          postImage: Image.network(_postImage2),
        ),
        const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
        PostContainer(
          name: _name,
          username: _username,
          postMessage: _postMessage,
          postImage: Image.network(_postImage),
        ),
        const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
        PostContainer(
          name: _name,
          username: _username,
          postMessage: _postMessage,
          postImage: Image.network(_postImage2),
        ),
        const Divider(thickness: 0.57, color: spqLightGreyTranslucent),
        PostContainer(
          name: _name,
          username: _username,
          postMessage: _postMessage,
          postImage: Image.network(_postImage),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _profileBloc.close();
    _resourceBloc.close();
    super.dispose();
  }
}
