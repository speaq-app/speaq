import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({Key? key}) : super(key: key);

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

  _buildFollowingList() {
    return Container(
      child: Text("Following"),
    );
  }
}
