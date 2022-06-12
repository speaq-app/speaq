import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/blocs/post_bloc/post_bloc.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/pages/base/home/user_menu.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_post_container.dart';
import 'package:frontend/widgets/spq_fab.dart';
import 'package:frontend/widgets_shimmer/all_widgets_shimmer.dart';
import 'package:frontend/widgets_shimmer/post_shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfileBloc _profileBloc = ProfileBloc();
  final ResourceBloc _resourceBloc = ResourceBloc();
  final PostBloc _postBloc = PostBloc();

/*
  final String _postMessage = "Welcome to our presentation, how are you ? Just did something lit here!!! yeah #speaq #beer";
  final String _name = "Informatics";
  final String _username = "@hhn";
  final String _postImage = "https://images.ctfassets.net/l3l0sjr15nav/dGLEVnJ6E3IuJE4NNFX4z/418da4b5783fa29d4abcabb7c37f71b7/2020-06-11_-_Wie_man_schnell_ein_GIF_erstellt.gif";
  final String _postImage2 = "https://www.architekten-online.com/media/03_-hhn-hochschule-heilbronn.jpg";
*/

  String spqImage = "assets/images/logo/speaq_logo.svg";

  //Remove?
  var postList = <Widget>[
    const SizedBox(height: 300),
    const Text("Error - Pls Refresh"),
    const SizedBox(height: 300),
    const Text("Error - Pls Refresh"),
    const SizedBox(height: 300),
    const Text("Error - Pls Refresh"),
    const SizedBox(height: 300),
    const Text("Error - Pls Refresh"),
    const SizedBox(height: 300),
    const Text("Error - Pls Refresh"),
  ];

  late ScrollController _scrollController;
  bool showBackToTopButton = false;

  @override
  void initState() {
    //Change from Hardcoded
    _profileBloc.add(LoadProfile(userId: 1, fromCache: false));
    //If no internet connection Load from cache?
    _postBloc.add(LoadPosts(userId: 1));
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            showBackToTopButton = true;
          } else {
            showBackToTopButton = false;
          }
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listener: (context, state) {
            if (state is ProfileLoaded) {
              _resourceBloc.add(LoadResource(resourceId: state.profile.profileImageResourceId));
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Scaffold(
                appBar: SpqAppBarShimmer(preferredSize: deviceSize),
                body: _buildPostView(),
                floatingActionButton: _buildFloatingActionButton(),
              );
            } else if (state is ProfileLoaded) {
              return Scaffold(
                appBar: _buildLoadedAppBar(deviceSize, state.profile),
                drawer: const UserMenu(),
                body: _buildPostView(),
                floatingActionButton: _buildFloatingActionButton(),
              );
            } else {
              return const Text("Profile State failed");
            }
          },
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    log("Load Posts");
    _postBloc.add(LoadPosts(userId: 1));
    /*
    postList = <Widget>[
      const SizedBox(height: 10),
      PostContainer(
        name: _name,
        username: _username,
        postMessage: _postMessage,
      ),
      const Divider(thickness: 1, color: spqLightGreyTranslucent),
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
    ];
    */
  }

  PreferredSizeWidget _buildLoadedAppBar(Size deviceSize, Profile profile) {
    return SpqAppBar(
      actionList: [
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          color: spqPrimaryBlue,
          iconSize: 25,
          onPressed: () => {},
        )
      ],
      leading: Builder(builder: (context) {
        return _buildProfileImage(context, profile.profileImageBlurHash);
      }),
      title: Center(
        child: InkWell(
          onTap: () {
            _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.linear);
          },
          child: SvgPicture.asset(
            spqImage,
            height: deviceSize.height * 0.055,
            alignment: Alignment.center,
          ),
        ),
      ),
      preferredSize: deviceSize,
    );
  }

  Widget _buildPostView() {
    return BlocBuilder<PostBloc, PostState>(
      bloc: _postBloc,
      builder: (context, state) {
        if (state is PostsLoaded) {
          return SingleChildScrollView(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 20,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if(index < state.postList.length){
                  return PostContainer(
                  name: "Name $index",
                  username: "Username $index",
                  creationTime: state.postList.elementAt(index).date,
                  postMessage: state.postList.elementAt(index).description,

                );
                }
                return const Text("hallo");
              },
            ),
          );
        } else if (state is PostsLoading) {
          return _buildPostContainerShimmer();
        } else {
          return const Text("Post State Failed.");
        }
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return SpqFloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, 'new_post'),
      heroTag: 'post',
      child: const Icon(
        Icons.add,
        size: 35,
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, String profileImageBlurHash) {
    return IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: BlocBuilder<ResourceBloc, ResourceState>(
        bloc: _resourceBloc,
        builder: (context, state) {
          if (state is ResourceLoaded) {
            return CircleAvatar(
              radius: 20,
              backgroundImage: MemoryImage(state.decodedData),
            );
          } else {
            return CircleAvatar(
              radius: 20,
              backgroundImage: BlurHashImage(profileImageBlurHash),
            );
          }
        },
      ),
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
    _postBloc.close();
    _scrollController.dispose();
    super.dispose();
  }
}
