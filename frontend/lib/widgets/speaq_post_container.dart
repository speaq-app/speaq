import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_audio_post_container.dart';
import 'package:frontend/widgets_shimmer/components/shimmer_cube.dart';
import 'package:frontend/widgets_shimmer/components/shimmer_profile_picture.dart';
import 'package:intl/intl.dart';

class PostContainer extends StatefulWidget {
  final int ownerID;
  final DateTime creationTime;
  final int numberOfLikes;
  final int numberOfComments;

  final String resourceMimeType;
  final String postMessage;

  final int resourceID;
  final String resourceBlurHash;

  const PostContainer({
    Key? key,
    required this.ownerID,
    required this.creationTime,
    required this.numberOfLikes,
    required this.numberOfComments,
    required this.resourceMimeType,
    this.resourceID = 0,
    this.postMessage = "",
    this.resourceBlurHash = "",
  }) : super(key: key);

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  final ProfileBloc _profileBloc = ProfileBloc();
  final ResourceBloc _resourceBlocPost = ResourceBloc();
  final ResourceBloc _resourceBlocProfile = ResourceBloc();

  @override
  void initState() {
    super.initState();

    _profileBloc.add(LoadProfile(userId: widget.ownerID));

    if (widget.resourceID > 0) {
      _resourceBlocPost.add(LoadResource(resourceId: widget.resourceID));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return Column(
      children: [
        ListTile(
          leading: _buildOwnerPicture(),
          title: _buildPostTitle(),
          subtitle: _buildContent(appLocale),
        ),
      ],
    );
  }

  Widget _buildOwnerPicture() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) {
        if (state is ProfileLoaded) {
          var profileImageResourceId = state.profile.profileImageResourceId;
          if (profileImageResourceId > 0) {
            _resourceBlocProfile
                .add(LoadResource(resourceId: profileImageResourceId));
          }
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          Profile profile = state.profile;
          return InkWell(
            onTap: () => Navigator.pushNamed(context, "profile", arguments: [
              widget.ownerID,
              state.profile.isOwnProfile,
              state.profile.isOwnProfile ? 0 : 1,
            ]),
            child: BlocBuilder<ResourceBloc, ResourceState>(
              bloc: _resourceBlocProfile,
              builder: (context, state) {
                if (state is ResourceLoaded) {
                  return CircleAvatar(
                    radius: 24,
                    backgroundImage: MemoryImage(state.decodedData),
                  );
                } else if (profile.profileImageBlurHash.isNotEmpty) {
                  return CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        BlurHashImage(profile.profileImageBlurHash),
                  );
                } else {
                  return CircleAvatar(
                    radius: 24,
                    backgroundColor: spqPrimaryBlue,
                    child: Text(profile.name[0]),
                  );
                }
              },
            ),
          );
        } else {
          return const ShimmerProfilePicture(diameter: 10);
        }
      },
    );
  }

  Widget _buildPostTitle() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      builder: (context, state) {
        if (state is! ProfileLoaded) {
          return Row(
            children: const [
              Expanded(
                child: ShimmerCube(width: 1, height: 4),
              ),
              SizedBox(width: 100),
              Expanded(
                child: ShimmerCube(width: 0.1, height: 3),
              ),
            ],
          );
        }

        return InkWell(
          onTap: () => Navigator.pushNamed(context, "profile", arguments: [
            widget.ownerID,
            state.profile.isOwnProfile,
            state.profile.isOwnProfile ? 0 : 1,
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  state.profile.name,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "@${state.profile.username}",
                    style: const TextStyle(fontSize: 12, color: spqDarkGrey),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(AppLocalizations appLocale) {
    final String formattedDate = _formatDate(appLocale);
    bool hasText = widget.postMessage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: hasText,
          child: Text(
            widget.postMessage,
            overflow: TextOverflow.clip,
            style: const TextStyle(color: spqBlack, fontSize: 15),
          ),
        ),
        const SizedBox(height: 10),
        _buildCorrectPostItem(),
        const SizedBox(height: 5),
        _buildReactionList(),
        _buildDateAndDivider(formattedDate),
      ],
    );
  }

  String _formatDate(AppLocalizations appLocale) {
    final DateTimeRange calculatedDateTime =
        DateTimeRange(start: widget.creationTime, end: DateTime.now());
    if (calculatedDateTime.duration.inMinutes < 1) {
      return calculatedDateTime.duration.inSeconds.toString() +
          appLocale.secondsAgo;
    }
    if (calculatedDateTime.duration.inMinutes < 2) {
      return calculatedDateTime.duration.inMinutes.toString() +
          appLocale.minuteAgo;
    }

    if (calculatedDateTime.duration.inHours < 1) {
      return calculatedDateTime.duration.inMinutes.toString() +
          appLocale.minutesAgo;
    }

    if (calculatedDateTime.duration.inHours < 2) {
      return calculatedDateTime.duration.inHours.toString() + appLocale.hourAgo;
    }

    if (calculatedDateTime.duration.inDays < 1) {
      return calculatedDateTime.duration.inHours.toString() +
          appLocale.hoursAgo;
    }

    if (calculatedDateTime.duration.inDays < 2) {
      return calculatedDateTime.duration.inDays.toString() + appLocale.dayAgo;
    }

    if (calculatedDateTime.duration.inDays < 7) {
      return calculatedDateTime.duration.inDays.toString() + appLocale.daysAgo;
    }

    if (calculatedDateTime.duration.inDays < 14) {
      return (calculatedDateTime.duration.inDays ~/ 7).toString() +
          appLocale.weekAgo;
    }

    if (calculatedDateTime.duration.inDays < 31) {
      return (calculatedDateTime.duration.inDays ~/ 7).toString() +
          appLocale.weeksAgo;
    }

    final DateFormat formatter = DateFormat("d. MMMM y");
    return appLocale.dateAt + formatter.format(widget.creationTime);
  }

  Widget _buildCorrectPostItem() {
    return BlocBuilder<ResourceBloc, ResourceState>(
      bloc: _resourceBlocPost,
      builder: (context, state) {
        if (state is ResourceLoaded) {
          switch (widget.resourceMimeType) {
            case "image/gif":
            case "image/jpeg":
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(image: MemoryImage(state.decodedData)),
              );
            case "audio/pcm16":
              return SpqAudioPostContainer(
                audioData: state.decodedData,
                durationInMillis: state.resource.audioDurationInMillis,
              );
            case "audio/mp3":
              return SpqAudioPostContainer(
                audioData: state.decodedData,
                durationInMillis: state.resource.audioDurationInMillis,
                codec: Codec.mp3,
              );
            default:
              return const Text("Media Type not implemented yet");
          }
        } else if (widget.resourceBlurHash.isNotEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(image: BlurHashImage(widget.resourceBlurHash)),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildReactionList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconWithText(
              const Icon(Icons.mic, color: spqDarkGrey, size: 20),
              widget.numberOfComments.toString(),
            ),
            _buildIconWithText(
              const Icon(Icons.favorite, color: spqErrorRed, size: 20),
              widget.numberOfLikes.toString(),
            ),
            const Icon(Icons.ios_share, color: spqLightGrey, size: 20),
            const Icon(Icons.bookmark, color: spqLightGrey, size: 20)
          ],
        ),
      ],
    );
  }

  Widget _buildDateAndDivider(String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          formattedDate,
          style: const TextStyle(fontSize: 12, color: spqDarkGrey),
          maxLines: 1,
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
        const SizedBox(height: 5),
        const Divider(height: 2),
      ],
    );
  }

  Widget _buildIconWithText(Icon icon, String text) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(child: icon),
          TextSpan(text: text),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _profileBloc.close();
    _resourceBlocPost.close();
    _resourceBlocProfile.close();
  }
}
