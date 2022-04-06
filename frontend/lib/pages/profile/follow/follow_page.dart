import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  int follower = 22;
  int following = 14;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.username),
          bottom: TabBar(
            unselectedLabelColor: spqLightGrey,
            indicatorColor: spqPrimaryBlue,
            labelColor: spqPrimaryBlue,
            tabs: [
              Text(
                "$follower Follower",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "$following Following",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildFollowerList(), _buildFollowingList()],
        ),
      ),
    );
  }

  _buildFollowerList() {
    return Container(
      child: Text("Follower"),
    );
  }

  Widget _buildFollowingList() {
    return Container(
      child: Text("Following"),
    );
  }
}
