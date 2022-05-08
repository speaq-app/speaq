import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/api/model/profile.dart';
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

  final String langKey = "pages.base.home.";
  final String _postMessage = "Welcome to our presentation, how are you ? Just did something lit here!!! yeah #speaq #beer";
  final String _name = "Informatics";
  final String _username = "@hhn";
  final String _postImage = "https://images.ctfassets.net/l3l0sjr15nav/dGLEVnJ6E3IuJE4NNFX4z/418da4b5783fa29d4abcabb7c37f71b7/2020-06-11_-_Wie_man_schnell_ein_GIF_erstellt.gif";
  final String _postImage2 = "https://www.architekten-online.com/media/03_-hhn-hochschule-heilbronn.jpg";
  String profilePicture = "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";

  String spqImage = "assets/images/logo/speaq_logo.svg";

  late Uint8List memoryImage;

  late ScrollController _scrollController;
  bool showBackToTopButton = false;

  @override
  void initState() {
    //Change from Hardcoded
    _profileBloc.add(LoadProfile(userId: 1));
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
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;

    return SafeArea(
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
              body: _buildListViewShimmer(context, appLocale),
            );
          } else if (state is ProfileLoaded) {
            return _buildHomePage(context, deviceSize, state.profile);
          } else {
            return const Text("State failed");
          }
        },
      ),
    );
  }

  Scaffold _buildHomePage(BuildContext context, Size deviceSize, Profile profile) {
    return Scaffold(
      appBar: SpqAppBar(
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
      ),
      drawer: const UserMenu(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
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
        ),
      ),
      floatingActionButton: SpqFloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'new_post'),
        heroTag: 'post',
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, String profileImageBlurHash) {
    return IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: BlocConsumer<ResourceBloc, ResourceState>(
        bloc: _resourceBloc,
        listener: (context, state) {
          if (state is ResourceLoaded) {
            memoryImage = base64Decode(state.resource.data);
          }
        },
        builder: (context, state) {
          if (state is ResourceLoaded) {
            return CircleAvatar(
              radius: 20,
              backgroundImage: MemoryImage(memoryImage),
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

  Widget _buildListViewShimmer(BuildContext context, AppLocalizations appLocale) {
    return ListView(
      children: [
        PostShimmer(appLocale: appLocale, hasImage: false),
        PostShimmer(appLocale: appLocale, hasImage: true),
        PostShimmer(appLocale: appLocale, hasImage: true),
        PostShimmer(appLocale: appLocale, hasImage: false),
        PostShimmer(appLocale: appLocale, hasImage: false),
        PostShimmer(appLocale: appLocale, hasImage: true),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
