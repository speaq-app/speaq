import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/all_utils.dart';

class FollowerTile extends StatelessWidget {
  final CondensedUser follower;
  final Function()? onPop;

  const FollowerTile({Key? key, required this.follower, this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ResourceBloc resourceBlocProfile = ResourceBloc();
    if (follower.profileImageBlurHash.isNotEmpty) {
      resourceBlocProfile.add(
          LoadResource(resourceId: follower.profileImageResourceId.toInt()));
    }
    return ListTile(
      onTap: () => Navigator.pushNamed(context, "profile",
          arguments: [follower.id.toInt(),1]),
      leading: BlocBuilder<ResourceBloc, ResourceState>(
          bloc: resourceBlocProfile,
          builder: (context, state) {
            if (state is ResourceLoaded) {
              return CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.07,
                foregroundImage: MemoryImage(state.decodedData),
                backgroundImage: BlurHashImage(follower.profileImageBlurHash),
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
    );
  }
}
