import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/speaq_styles.dart';

class SpqProfileAvatar extends StatefulWidget {
  final Profile profile;

  const SpqProfileAvatar({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  State<SpqProfileAvatar> createState() => _SpqProfileAvatarState();
}

class _SpqProfileAvatarState extends State<SpqProfileAvatar> {
  final ResourceBloc _resourceBloc = ResourceBloc();

  @override
  void initState() {
    super.initState();

    var profileImageResourceId = widget.profile.profileImageResourceId;
    if (profileImageResourceId > 0) {
      _resourceBloc.add(LoadResource(resourceId: profileImageResourceId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceBloc, ResourceState>(
      bloc: _resourceBloc,
      builder: (context, state) {
        if (state is ResourceLoaded) {
          return Stack(
            children: [
              CircleAvatar(
                radius: 24,
                foregroundImage: MemoryImage(state.decodedData),
                backgroundImage:
                    BlurHashImage(widget.profile.profileImageBlurHash),
              ),
            ],
          );
        } else if (widget.profile.profileImageBlurHash.isNotEmpty) {
          return CircleAvatar(
            radius: 24,
            backgroundImage: BlurHashImage(widget.profile.profileImageBlurHash),
          );
        } else {
          return CircleAvatar(
            radius: 24,
            backgroundColor: spqPrimaryBlue,
            child: Text(widget.profile.name[0]),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _resourceBloc.close();
  }
}
