import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets_shimmer/components/shimmer_cube.dart';
import 'package:shimmer/shimmer.dart';

import 'components/shimmer_profile_picture.dart';

class PostShimmer extends StatelessWidget {
  final bool hasImage;
  final bool hasAudio;

  const PostShimmer({
    Key? key,
    this.hasImage = false,
    this.hasAudio = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: deviceSize.width / 100 * 2),
        ListTile(
          leading: const ShimmerProfilePicture(diameter: 10),
          title: _buildTitleRow(deviceSize),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostContent(deviceSize),
              SizedBox(height: deviceSize.width / 100 * 3),
              _buildActionRow(deviceSize),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleRow(Size deviceSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: deviceSize.width / 100 * 1),
        const ShimmerCube(width: 100, height: 5),
        SizedBox(height: deviceSize.width / 100 * 1),
      ],
    );
  }

  Widget _buildPostContent(Size deviceSize) {
    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerCube(width: 100, height: 5),
              SizedBox(height: deviceSize.width / 100 * 1),
              const ShimmerCube(width: 25, height: 5),
              SizedBox(height: deviceSize.width / 100 * 1),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: hasImage,
                child: const ShimmerCube(width: 100, height: 50),
              ),
              Visibility(
                visible: hasAudio,
                child: Column(
                  children: [
                    SizedBox(height: deviceSize.width / 100 * 5),
                    const ShimmerCube(width: 60, height: 10),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionRow(Size deviceSize) {
    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mic,
            color: spqDarkGrey,
            size: deviceSize.width / 100 * 5,
          ),
          SizedBox(width: deviceSize.width / 100 * 15),
          Icon(
            Icons.favorite,
            color: spqErrorRed,
            size: deviceSize.width / 100 * 5,
          ),
          SizedBox(width: deviceSize.width / 100 * 15),
          Icon(
            Icons.ios_share,
            color: spqDarkGrey,
            size: deviceSize.width / 100 * 5,
          ),
          SizedBox(width: deviceSize.width / 100 * 15),
          Icon(
            Icons.bookmark,
            color: spqDarkGrey,
            size: deviceSize.width / 100 * 5,
          )
        ],
      ),
    );
  }
}
