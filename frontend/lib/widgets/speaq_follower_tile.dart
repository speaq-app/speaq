import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/blocs/follower_bloc/follower_bloc.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/utils/all_utils.dart';

class FollowerTile extends StatefulWidget {
  final String followerImage;
  final FollowUser follower;
  final int userID;
  final bool checkFollowing;
  final Function() onPop;

  const FollowerTile({Key? key, required this.follower, required this.followerImage, this.checkFollowing = false, required this.userID, required this.onPop}) : super(key: key);

  @override
  State<FollowerTile> createState() => _FollowerTileState();
}

class _FollowerTileState extends State<FollowerTile> {
  final FollowerBloc _followerBloc = FollowerBloc();
  bool isFollowing = true;

  @override
  void initState() {
    super.initState();

    if (widget.checkFollowing) {
      // followerBloc.add(Chec)
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return ListTile(
      onTap: () => Navigator.pushNamed(context, "profile", arguments: [widget.follower.id.toInt(), false, widget.userID]).then((value) => widget.onPop),
      leading: Hero(tag: widget.followerImage, child: CircleAvatar(radius: MediaQuery.of(context).size.width * 0.07)),
      title: Text(
        widget.follower.name,
        style: const TextStyle(fontSize: 18.0, color: spqBlack, fontWeight: FontWeight.w900),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.follower.username, style: const TextStyle(fontSize: 16.0, color: spqLightGrey)),
        ],
      ),
      isThreeLine: false,
/*      trailing: BlocConsumer<FollowerBloc, FollowerState>(
        bloc: _followerBloc,
        listener: (context, state) {
          if (state is FollowedUnfollowLoaded) {
            isFollowing = state.isFollowing;
          }
        },
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () {
              _followerBloc.add(FollowUnfollow(userID: widget.userID, followerID: widget.follower.id.toInt()));
            },
            style: ElevatedButton.styleFrom(
              primary: spqWhite,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: BorderSide(
                  color: isFollowing ? spqLightRed : spqPrimaryBlue,
                ),
              ),
            ),
            child: Text(
              isFollowing ? appLocale.toUnfollow : appLocale.toFollow,
              style: TextStyle(color: isFollowing ? spqLightRed : spqPrimaryBlue),
            ),
          );
        },
      ),*/
    );
  }
}
