import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/blocs/post_bloc/post_bloc.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/pages/base/home/user_menu.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_fab.dart';
import 'package:frontend/widgets/speaq_profile_avatar.dart';
import 'package:frontend/widgets_shimmer/all_widgets_shimmer.dart';
import 'package:frontend/widgets_shimmer/post_shimmer.dart';
import 'package:frontend/widgets/all_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
    _profileBloc.add(LoadProfile(fromCache: false));
    // Load from cache.
    _postBloc.add(LoadPosts());
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
              var profileImageResourceId = state.profile.profileImageResourceId;
              if (profileImageResourceId > 0) {
                _resourceBloc
                    .add(LoadResource(resourceId: profileImageResourceId));
              }
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
                drawer: const UserMenu(),
                body: _buildPostView(appLocale),
                floatingActionButton: _buildFloatingActionButton(),
              );
            } else {
              return const SizedBox(
                height: 0,
              );
            }
          },
        ),
      ),
    );
  }

  /// Jumps to the top of [HomePage] and updates automatically.
  Future<void> _pullRefresh() async {
    _postBloc.add(LoadPosts());
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
        return _buildProfileImage(context, profile);
      }),
      title: Center(
        child: InkWell(
          onTap: () {
            _scrollController.animateTo(0,
                duration: const Duration(seconds: 1), curve: Curves.linear);
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

  /// Returns a [BlockBuilder] for different post states.
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

  /// Returns a [SpqFloatingActionButton] for posting a new post.
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

  Widget _buildProfileImage(BuildContext context, Profile profile) {
    return IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: SpqProfileAvatar(profile: profile),
    );
  }

  /// Returns a [ListView] containing a list of posts.
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
                creationTime: state.postList.elementAt(index).date,
                postMessage: state.postList.elementAt(index).description,
                resourceID: state.postList.elementAt(index).resourceID,
                numberOfLikes: state.postList.elementAt(index).numberOfLikes,
                numberOfComments:
                    state.postList.elementAt(index).numberOfComments,
                resourceMimeType: state.postList.elementAt(index).mimeType,
              );
            }
            return _buildFeedFooter(appLocale);
          },
        ),
      ],
    );
  }

  /// Creates and returns a [Column] to build a FeedFooter.
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

  /// Returns a [ListView] for different postShimmer effects.
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
