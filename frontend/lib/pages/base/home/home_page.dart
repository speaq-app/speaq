import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/pages/base/home/user_menu.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/spq_fab.dart';
import 'package:frontend/widgets_shimmer/all_widgets_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfileBloc _profileBloc = ProfileBloc();

  final String langKey = "pages.base.home.";

  String profilePicture =
      "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";
  String spqImage = "assets/images/logo/speaq_logo.svg";

  late ScrollController _scrollController;
  bool _showBackToTopButton = false;

  @override
  void initState() {
    _profileBloc.add(LoadProfile(userId: 1));
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: _profileBloc,
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Scaffold(
              appBar: SpqAppBarShimmer(preferredSize: deviceSize),
              body: Container(child: _buildListViewShimmer(context)),
            );
          } else if (state is ProfileLoaded) {
            return _buildHomePage(deviceSize, context);
          } else {
            return const Text("State failed");
          }
        },
      ),
    );
  }

  Scaffold _buildHomePage(Size deviceSize, BuildContext context) {
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
          return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profilePicture),
              ));
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
      ),
      drawer: const UserMenu(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // add a bunch of containers to make the screen longer
            Container(
              height: 200,
              color: Colors.amber,
            ),
            Container(
              height: 200,
              color: Colors.blue[100],
            ),
            Container(
              height: 200,
              color: Colors.red[200],
            ),
            Container(
              height: 200,
              color: Colors.orange,
            ),
            Container(
              height: 200,
              color: Colors.yellow,
            ),
            Container(
              height: 200,
              color: Colors.lightGreen,
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

  _buildListViewShimmer(BuildContext context) {
    return ListView(
      children: [
        _buildShimmerPost(),
        _buildShimmerPost(),
        _buildShimmerPost(),
        _buildShimmerPost(),
        _buildShimmerPost(),
      ],
    );
  }

  Widget _buildShimmerPost() {
    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: Container(
        height: 200,
        color: spqPrimaryBlue,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
