import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:shimmer/shimmer.dart';

class PostShimmer extends StatelessWidget {
  final AppLocalizations appLocale;
  final bool hasImage;

  const PostShimmer({
    Key? key,
    required this.appLocale,
    required this.hasImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        ListTile(
          leading: _buildProfilePicture(),
          title: _buildTitleRow(),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostContent(),
              const SizedBox(height: 5),
              _buildActionRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: const CircleAvatar(radius: 20),
    );
  }

  Widget _buildTitleRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerCube(300),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildPostContent() {
    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerCube(300),
          const SizedBox(height: 5),
          _buildShimmerCube(120),
          const SizedBox(height: 5),
          Visibility(
            visible: hasImage,
            child: const SizedBox(
                height: 200,
                width: 300,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: spqBackgroundGrey),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCube(double width) {
    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: SizedBox(
        width: width,
        height: 18,
        child: const DecoratedBox(
          decoration: BoxDecoration(color: spqBlack),
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.mic, color: spqDarkGrey),
          SizedBox(width: 30),
          Icon(Icons.favorite, color: spqErrorRed),
          SizedBox(width: 30),
          Icon(Icons.ios_share, color: spqDarkGrey),
          SizedBox(width: 30),
          Icon(Icons.bookmark, color: spqDarkGrey)
        ],
      ),
    );
  }
}
