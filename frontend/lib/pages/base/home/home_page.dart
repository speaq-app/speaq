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
  final int userID;
  const HomePage({Key? key, required this.userID}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfileBloc _profileBloc = ProfileBloc();
  final ResourceBloc _resourceBloc = ResourceBloc();
  final PostBloc _postBloc = PostBloc();

  String spqImage = "assets/images/logo/speaq_logo.svg";

  var postList = <Widget>[];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //Change from Hardcoded
    _profileBloc.add(LoadProfile(userId: 1, fromCache: false));
    //If no internet connection Load from cache?
    _postBloc.add(LoadPosts(userId: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    AppLocalizations appLocale = AppLocalizations.of(context)!;

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
                body: _buildPostView(appLocale),
                floatingActionButton: _buildFloatingActionButton(),
              );
            } else if (state is ProfileLoaded) {
              return Scaffold(
                appBar: _buildLoadedAppBar(deviceSize, state.profile),
                drawer: UserMenu(userID: widget.userID,),
                body: _buildPostView(appLocale),
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
    //Change from Hardcoded
    _postBloc.add(LoadPosts(userId: 1));
    _scrollController.jumpTo(0);
  }

  PreferredSizeWidget _buildLoadedAppBar(Size deviceSize, Profile profile) {
    return SpqAppBar(
      actionList: [
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          color: spqLightGrey,
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

  Widget _buildPostView(AppLocalizations appLocale) {
    return BlocBuilder<PostBloc, PostState>(
      bloc: _postBloc,
      builder: (context, state) {
        if (state is PostsLoaded) {
          return _buildPostList(state, appLocale);
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

  Widget _buildPostList(PostsLoaded state, AppLocalizations appLocale) {
    return ListView(
      controller: _scrollController,
      children: [
        ListView.builder(
          controller: _scrollController,
          itemCount: state.postList.length + 1,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index < state.postList.length) {
              return PostContainer(
                ownerID: state.postList.elementAt(index).ownerID,
                name: state.postList.elementAt(index).ownerName,
                username: state.postList.elementAt(index).ownerUsername,
                creationTime: state.postList.elementAt(index).date,
                postMessage: state.postList.elementAt(index).description,
                resourceID: -1, //Only Text
                numberOfLikes: state.postList.elementAt(index).numberOfLikes,
                numberOfComments: state.postList.elementAt(index).numberOfComments,
              );
            }
            return _buildFeedFooter(appLocale);
          },
        ),
      ],
    );
  }

  Widget _buildFeedFooter(AppLocalizations appLocale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Text(appLocale.noMorePosts),
        const SizedBox(height: 30),
        Text(
          appLocale.followOthersForMorePosts,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        IconButton(
          onPressed: _pullRefresh,
          icon: const Icon(
            Icons.refresh,
            size: 40,
          ),
        ),
        const SizedBox(height: 400),
      ],
    );
  }

  Widget _buildPostContainerShimmer() {
    return ListView(
      controller: _scrollController,
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
