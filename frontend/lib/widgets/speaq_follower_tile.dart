import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/all_utils.dart';

class FollowerTile extends StatelessWidget {
  final CondensedUser follower;
  final Function()? onPop;

  const FollowerTile({Key? key, required this.follower, this.onPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ResourceBloc resourceBlocProfile = ResourceBloc();
    if(follower.profileImageBlurHash.isNotEmpty){
      resourceBlocProfile.add(LoadResource(resourceId: follower.profileImageResourceId.toInt()));
    }
    return ListTile(
      onTap: () => Navigator.pushNamed(context, "profile", arguments: [follower.id.toInt(), false, 0]).then((value) => onPop),
      leading: BlocBuilder<ResourceBloc, ResourceState>(
          bloc: resourceBlocProfile,
          builder: (context, state) {
            if (state is ResourceLoaded) {
              return CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.07,
                backgroundImage: MemoryImage(state.decodedData),
              );
            } else if (follower.profileImageBlurHash.isNotEmpty) {
              return CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.07,
                backgroundImage: BlurHashImage(follower.profileImageBlurHash),
              );
            } else {
              return CircleAvatar(
                radius: 24,
                backgroundColor: spqPrimaryBlue,
                child: Text(follower.name[0]),
              );
            }
          }),
      title: Text(
        follower.name,
        style: const TextStyle(
          fontSize: 18.0,
          color: spqBlack,
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            follower.username,
            style: const TextStyle(fontSize: 16.0, color: spqLightGrey),
          ),
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
