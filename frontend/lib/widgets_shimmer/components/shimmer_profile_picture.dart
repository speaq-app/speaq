import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:shimmer/shimmer.dart';

/// radius should be between 1 and 100; representing a percentage of the available space.
class ShimmerProfilePicture extends StatelessWidget {
  final double diameter;

  const ShimmerProfilePicture({
    Key? key,
    required this.diameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: CircleAvatar(radius: deviceSize.width / 100 * diameter / 2),
    );
  }
}
